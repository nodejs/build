#!/usr/bin/env bash

if [ -z ${srcdir+x} ]; then
  echo "\$srcdir is not set"
  exit 1
fi

if [ -z ${dstdir+x} ]; then
  echo "\$dstdir is not set"
  exit 1
fi

version=$1

for subdir in $(cd $srcdir && ls); do

  if [ -d "${srcdir}/${subdir}" ]; then
    resha=no

    if [ "X${version}" != "X" ] && [ "X${version}" != "X${subdir}" ]; then
      continue
    fi

    for donefile in $(cd ${srcdir}/${subdir} && ls *.done 2> /dev/null); do
      doneref=$(echo $donefile | sed 's/\.done$//')

      if [[ -f "${srcdir}/${subdir}/${doneref}" || -d "${srcdir}/${subdir}/${doneref}" ]]; then
        echo "Promoting ${subdir}/${doneref}..."
        mkdir -p "${dstdir}/${subdir}"
        rm -rf "${dstdir}/${subdir}/${doneref}"
        cp -a "${srcdir}/${subdir}/${doneref}" "${dstdir}/${subdir}/${doneref}"
        rm -rf "${srcdir}/${subdir}/${doneref}"
        resha=yes
      fi

      rm -f "${srcdir}/${subdir}/${donefile}"

    done

    if [ "X${version}" == "X" ] && [ "$resha" == "yes" ]; then
      /home/staging/promote/_resha.sh $dstdir $subdir
    fi

  fi

done
