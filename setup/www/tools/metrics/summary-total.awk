BEGIN {
  FS = ","
}

/^day,/ { next }

{
  totals[$1] += $2
  bytes[$1] += $3
}

END {
  PROCINFO["sorted_in"] = "@ind_str_asc"
  print "day,downloads,TiB"
  for (day in totals) {
    printf "%s,%s,%s\n", day, totals[day], bytes[day] / 1024
  }
}
