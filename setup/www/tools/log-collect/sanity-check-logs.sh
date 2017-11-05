#!/bin/bash

set -e

fmt="%b %e %H:00:00 UTC %Y"
earliest=$(date --date="25 hours ago" +"%s")
end=$(date +"$fmt")
zone=nodejs.org
logdir="/home/logs/$zone"
latestminute=57

# Grab the last entry of the file, parse it and extract the timestamp,
# then check that the timestamp is reasonably late—on a busy site it should
# be in the 59th minute because we expect many requests per minute of the
# hour. If the time of the last entry seems too early then delete the file and
# expect the log fetcher to grab it again and hopefully get it right.
checkfile() {
  local file=$1
  local lastjson="$(xzcat $file | tail -1)"
  local lastminute=$(node -p 'new Date(Math.round(JSON.parse(process.argv[1]).timestamp / 1000000)).getMinutes()' "$lastjson")
  echo $file = $lastminute
  if (( $lastminute < $latestminute )); then
    echo "Bad file $file, last minute = $lastminute"
    rm $file
  fi
}

while true; do
  # file format is <start timestamp>-<end timestamp>.log.xz and there's one per hour
  # we start from the last hour and work back 25 hours (1 hour overlap for safety)
  start=$(date --date="${end}-1 hour" +"$fmt")
  startts=$(date --date="$start" +"%s")
  endts=$(date --date="$end" +"%s")
  if (( $startts < $earliest )); then break; fi

  filename="${startts}-${endts}.log.xz"
  logfile="${logdir}/${filename}"
  if [ -f $logfile ]; then
    checkfile $logfile
  fi

  end="$start"
done
