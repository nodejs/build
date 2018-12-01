#!/usr/bin/env bash

set -e

__dirname="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
outputdir=/home/dist/metrics
logsoutputdir=${outputdir}/logs
summariesoutputdir=${outputdir}/summaries
summarytypes="arch country os total version"

mkdir -p $logsoutputdir
for type in $summarytypes; do
  mkdir -p ${summariesoutputdir}/${type}
done

function catfile {
  file=$1
  if [[ $i =~ \.xz ]]; then
    xzcat $1
  elif [[ $i =~ \.gz ]]; then
    zcat $1
  else
    cat $1
  fi
}


function processfile {
  basename=$1
  infile=$2
  outfile=$3
  tmpout="/tmp/~${basename}"

  echo "Processing ${infile} ..."
  catfile $infile \
    | gawk -f ${__dirname}/download-counts.awk \
    | ${__dirname}/country-lookup.py \
    > $tmpout
  echo "Moving data to ${outfile} ..."
  mv $tmpout $outfile
}


function processsummaries {
  basename=$1
  infile=$2
  tmpdir="/tmp/~${basename}.summary"

  echo "Processing summaries for ${infile} ..."
  (
    mkdir -p $tmpdir && \
    cd $tmpdir && \
    gawk -f ${__dirname}/download-summaries.awk $infile
  )

  for type in $summarytypes; do
    mv ${tmpdir}/${type}.csv ${summariesoutputdir}/${type}/${basename}.csv
  done
  rm -rf $tmpdir
}


echo "Processing log files ..."

for i in $(ls /var/log/nginx/nodejs*/nodejs.org-access.log* | grep -v orig); do
  basename=$(basename $i | sed 's/\.[xg]z//')
  basenameout=$basename
  if [[ $i =~ nodejs-backup ]]; then
    basenameout="${basename}b"
  fi
  outfile=${logsoutputdir}/${basenameout}.csv
  summaryexists=true

  #if [ ! -f ${outfile} ]; then
  if [[ $i =~ nodejs\.org-access\.log$ ]] || [ ! -f ${outfile} -a ! -f ${outfile}.gz ]; then
    processfile $basename $i $outfile
    summaryexists=false
  fi

  for type in $summarytypes; do
    if [ ! -f ${summariesoutputdir}/${type}/${basenameout}.csv ]; then
      summaryexists=false
    fi
  done

  #summaryexists=true
  if [ "$summaryexists" = "false" ]; then
    processsummaries $basenameout $outfile
  fi
done;

echo "Processing final summaries ..."

for type in $summarytypes; do
  echo "  ... $type"
  gawk -f ${__dirname}/summary-${type}.awk ${summariesoutputdir}/${type}/*.csv > ${summariesoutputdir}/${type}.csv
done

echo "Creating graphs ..."
gnuplot -e "inputdir='${summariesoutputdir}'; outputdir='${summariesoutputdir}'" ${__dirname}/plot.gp
