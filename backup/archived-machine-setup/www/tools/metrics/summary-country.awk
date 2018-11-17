BEGIN {
  FS = ","
}

/^day,/ {
  for (i = 2; i <= NF; i++) {
    country_name[i] = $i
  }
  next
}

{
  for (i = 2; i <= NF; i++) {
    country[$1][country_name[i]] += $i
    countries[country_name[i]] += $i
  }
}

END {
  len = 0
  PROCINFO["sorted_in"] = "@val_num_desc"
  for (c in countries) {
    ocountries[++len] = c
  }
  delete PROCINFO["sorted_in"]

  printf "day"
  for (i = 1; i <= len; i++) {
    printf ",%s", ocountries[i]
  }
  printf "\n"

  PROCINFO["sorted_in"] = "@ind_str_asc"
  for (day in country) {
    printf "%s", day
    for (i = 1; i <= len; i++) {
      printf ",%s", country[day][ocountries[i]]
    }
    printf "\n"
  }
}
