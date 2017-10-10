#!/bin/bash

pidfile=/var/run/nodejs/sync-benchmarking.pid
cmd="
  rsync -aqz --delete benchmark:charts/ /home/www/benchmarking/charts/ &&
  rsync -aqz --delete benchmark:coverage-out/out/ /home/www/coverage/
"

if [ -a "$pidfile" -a -r "$pidfile" ]; then
  read pid < "$pidfile"
  if [ -n "${pid:-}" ]; then
    if $(kill -0 "${pid:-}" 2> /dev/null); then
      exit 0 # already running
    # else stale pid
    fi
  fi
fi

echo $$ > $pidfile
bash -c "$cmd"
rm $pidfile
