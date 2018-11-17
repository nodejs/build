#!/bin/sh

curl -sL http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz | gunzip -c - > GeoLite2-City.mmdb
