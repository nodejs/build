#!/usr/bin/env bash

if [ -x "$(command -v ccache)" ]; then

  eval "$( ccache -s | awk '
      /cache hit/ { hit=$4; }
      /cache miss/ { miss=$3; }
      /^cache size/ { used=$3$4; }
      /max cache size/ { free=$4$5; }
    END {
      if (hit+miss == 0)
        print "rate=0";
      else
        printf "rate=%.1f\n", hit*100 / (hit+miss);
      print "chit=" hit "; cmiss=" miss "; cused=" used "; cfree=" free ";"
    }' )"
  echo "hits: $chit, misses: $cmiss ($rate%) usage: $cused/$cfree"
  exit 0

else
  exit -1
fi
