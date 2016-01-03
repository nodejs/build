BEGIN {
  FS = ","
}

/^day,/ {
  for (i = 2; i <= NF; i++) {
    arch_name[i] = $i
  }
  next
}

{
  for (i = 2; i <= NF; i++) {
    arch[$1][arch_name[i]] += $i
    archs[arch_name[i]] += $i
  }
}

END {
  len = 0
  PROCINFO["sorted_in"] = "@val_num_desc"
  for (a in archs) {
    oarchs[++len] = a
  }
  delete PROCINFO["sorted_in"]

  printf "day"
  for (i = 1; i <= len; i++) {
    printf ",%s", oarchs[i]
  }
  printf "\n"

  PROCINFO["sorted_in"] = "@ind_str_asc"
  for (day in arch) {
    printf "%s", day
    for (i = 1; i <= len; i++) {
      printf ",%s", arch[day][oarchs[i]]
    }
    printf "\n"
  }
}
