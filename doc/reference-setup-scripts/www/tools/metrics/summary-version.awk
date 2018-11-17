BEGIN {
  FS = ","
}

/^day,/ {
  for (i = 2; i <= NF; i++) {
    version_name[i] = $i
  }
  next
}

{
  for (i = 2; i <= NF; i++) {
    version[$1][version_name[i]] += $i
    versions[version_name[i]] += $i
  }
}

# sort versions by semver, i.e. 1 < 0.10 < 0.1
function version_sort (i1, v1, i2, v2) {
  v1 = v1 * (match(v1, /^0.[0-9]$/) ? 10 : 100)
  v2 = v2 * (match(v2, /^0.[0-9]$/) ? 10 : 100)
  if (v1 < v2) return -1
  if (v1 > v2) return 1
  return 0
}

END {
  len = 0
  PROCINFO["sorted_in"] = "@val_num_desc"
  for (a in versions) {
    oversions[++len] = a
  }
  delete PROCINFO["sorted_in"]
  #asort(oversions, oversions, "version_sort")

  printf "day"
  for (i = 1; i <= len; i++) {
    printf ",%s", oversions[i]
  }
  printf "\n"

  PROCINFO["sorted_in"] = "@ind_str_asc"
  for (day in version) {
    printf "%s", day
    for (i = 1; i <= len; i++) {
      printf ",%s", version[day][oversions[i]]
    }
    printf "\n"
  }
}
