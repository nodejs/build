#!/usr/bin/env python

import csv
import os
import sys

import geoip2.database

reader = geoip2.database.Reader(os.path.dirname(os.path.realpath(__file__)) + '/GeoLite2-City.mmdb')

logFileWriter = csv.writer(sys.stdout, quoting=csv.QUOTE_MINIMAL)
logFileReader = csv.reader(sys.stdin)

for row in logFileReader:
  if row[0] == "ip":
    row.pop(0)
    row.insert(1, "country")
    row.insert(2, "region")
    logFileWriter.writerow(row)
    continue

  country = ""
  region = ""

  try:
    georec = reader.city(row.pop(0))
    if georec:
      if georec.country.iso_code:
        country = georec.country.iso_code
      if georec.subdivisions.most_specific.iso_code:
        region = georec.subdivisions.most_specific.iso_code
  except Exception:
    pass

  row.insert(1, country.encode('utf-8'))
  row.insert(2, region.encode('utf-8'))

  logFileWriter.writerow(row)
