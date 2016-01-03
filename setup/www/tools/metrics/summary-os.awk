BEGIN {
  FS = ","
}

/^day,/ {
  for (i = 2; i <= NF; i++) {
    os_name[i] = $i
  }
  next
}

{
  for (i = 2; i <= NF; i++) {
    os[$1][os_name[i]] += $i
    oss[os_name[i]] += $i
  }
}

END {
  len = 0
  PROCINFO["sorted_in"] = "@val_num_desc"
  for (a in oss) {
    ooss[++len] = a
  }
  delete PROCINFO["sorted_in"]

  printf "day"
  for (i = 1; i <= len; i++) {
    printf ",%s", ooss[i]
  }
  printf "\n"

  PROCINFO["sorted_in"] = "@ind_str_asc"
  for (day in os) {
    printf "%s", day
    for (i = 1; i <= len; i++) {
      printf ",%s", os[day][ooss[i]]
    }
    printf "\n"
  }
}
