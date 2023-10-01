#!/usr/bin/env bash

set -e

__dirname="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z ${srcdir+x} ]; then
  echo "\$srcdir is not set"
  exit 1
fi

if [ -z ${dstdir+x} ]; then
  echo "\$dstdir is not set"
  exit 1
fi

if [ -z ${dirmatch+x} ]; then
  echo "\$dirmatch is not set"
  exit 1
fi

site=$1
version=$2
purge=no

for subdir in $(cd $srcdir && ls); do

  if [ -d "${srcdir}/${subdir}" ] && [[ $subdir =~ $dirmatch ]]; then
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
        purge=yes
      fi

      rm -f "${srcdir}/${subdir}/${donefile}"

    done

    if [ "X${version}" == "X" ] && [ "$resha" == "yes" ]; then
      ${__dirname}/_resha.sh $site $dstdir $subdir
    fi

    . ${__dirname}/upload_to_cloudflare.sh $site $subdir

  fi

done

if [ "$purge" == "yes" ]; then
  /home/nodejs/queue-cdn-purge.sh $site promote
fi
