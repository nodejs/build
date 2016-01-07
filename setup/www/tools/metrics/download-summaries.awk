BEGIN {
  # proper CSV delimiting, including quoted fields containing commas
  FPAT = "([^,]*)|(\"[^\"]*\")"
}

# 1  ,2      ,3     ,4   ,5      ,6 ,7   ,8
# day,country,region,path,version,os,arch,bytes
# 2015-12-13,US,VA,/dist/v0.10.33/node-v0.10.33-linux-x64.tar.gz,v0.10.33,linux,x64,5645609

# skip headers
/^day,/ { next }

{
  day = $1
  totals[day]++
  country_names[$2]++
  countries[day][$2]++
  # take only the semver-minor for versions < 1 and only semver-major for >= 1
  if ($5 == "") {
    version = "unknown"
  } else {
    gsub("v", "", $5)
    split($5, versionSplit, ".")
    if (versionSplit[1] == 0) {
      version = "0." versionSplit[2]
    } else {
      version = versionSplit[1]
    }
  }
  version_names[version] = 1
  versions[day][version]++
  os_names[$6] = 1
  oss[day][$6]++
  arch_names[$7] = 1
  archs[day][$7]++
  bytes[day] += $8 / 1024 / 1024
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
  for (day in versions) {
    odays[++len] = day
  }
  asort(odays)

  PROCINFO["sorted_in"] = "@val_num_desc"
  clen = 0
  for (country in country_names) {
    ocountries[++clen] = country
    #if (i++ >= top_countries) break
  }
  delete PROCINFO["sorted_in"]

  vlen = 0
  for (version in version_names) {
    oversions[++vlen] = version
  }
  asort(oversions, oversions, "version_sort")

  olen = 0
  for (os in os_names) {
    ooss[++olen] = os
  }
  asort(ooss)

  alen = 0
  for (arch in arch_names) {
    oarchs[++alen] = arch
  }
  asort(oarchs)

  printf "day" > "country.csv"
  printf "day" > "version.csv"
  printf "day" > "os.csv"
  printf "day" > "arch.csv"
  printf "day,downloads,GiB\n" > "total.csv"
  for (i = 1; i <= clen; i++) {
    printf ",%s", ocountries[i] ? ocountries[i] : "unknown" > "country.csv"
  }
  for (i = 1; i <= vlen; i++) {
    printf ",%s", oversions[i] > "version.csv"
  }
  for (i = 1; i <= olen; i++) {
    printf ",%s", ooss[i] ? ooss[i] : "unknown" > "os.csv"
  }
  for (i = 1; i <= alen; i++) {
    printf ",%s", oarchs[i] ? oarchs[i] : "unknown" > "arch.csv"
  }
  printf "\n" > "country.csv"
  printf "\n" > "version.csv"
  printf "\n" > "os.csv"
  printf "\n" > "arch.csv"
  for (i = 1; i <= len; i++) {
    day = odays[i]
    printf "%s", day > "country.csv"
    printf "%s", day > "version.csv"
    printf "%s", day > "os.csv"
    printf "%s", day > "arch.csv"
    printf "%s,%s,%s\n", day, totals[day], bytes[day] / 1024 > "total.csv"

    for (j = 1; j <= clen; j++) {
      printf ",%s", countries[day][ocountries[j]] > "country.csv"
    }
    for (j = 1; j <= vlen; j++) {
      printf ",%s", versions[day][oversions[j]] > "version.csv"
    }
    for (j = 1; j <= olen; j++) {
      printf ",%s", oss[day][ooss[j]] > "os.csv"
    }
    for (j = 1; j <= alen; j++) {
      printf ",%s", archs[day][oarchs[j]] > "arch.csv"
    }
    printf "\n" > "country.csv"
    printf "\n" > "version.csv"
    printf "\n" > "os.csv"
    printf "\n" > "arch.csv"
  }
}
