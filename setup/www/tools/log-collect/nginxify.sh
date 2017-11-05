#!/bin/bash

set -e

export TZ=UTC

__dirname="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

zone="nodejs.org"
logdir="/home/logs/$zone"
nginxlogdir="/home/logs/$zone/nginx-format"

fmt="%b %e %H:00:00 UTC %Y"
earliest=$(date --date="72 hours ago" +"%s")
end=$(date --date="+1 hour" +"$fmt")

while true; do
  start=$(date --date="${end}-1 hour" +"$fmt")
  startts=$(date --date="$start" +"%s")
  endts=$(date --date="$end" +"%s")
  if (( $startts < $earliest )); then break; fi

  filename="${startts}-${endts}.log.xz"
  nginxfilename="${startts}-${endts}.log"
  infile="${logdir}/${filename}"
  nginxfile="${nginxlogdir}/${nginxfilename}"

  end="$start"
done
