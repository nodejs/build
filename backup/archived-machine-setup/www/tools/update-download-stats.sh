#!/bin/bash

outfile=/tmp/dld.txt

rm -f $outfile

for i in $(ls -r /var/log/nginx/iojs.org-access.log* | tail -3); do
 cat=cat
 if [[ "$i" =~ \.gz$ ]]; then
    cat=zcat
 fi
 #echo "processing $i..."
 $cat $i | awk '{ print $4, $10, $7 }'  | grep '\\.(pkg\|xz\|gz\|msi\|exe)$' | grep -E ' [0-9]{4,} ' | sed -r 's/^\[([^:]+)[^ ]+/\1/g' | sed 's/ \/.*\/iojs-/ /g' >> $outfile
done

#echo "wrote to $outfile, $(wc -l $outfile) lines"

awk '{

  all[$1][$3]++;
  days[$1]++;
}

END {
  PROCINFO["sorted_in"] = "@val_num_desc";

  print "statfile = \"/home/iojs/download-stats.json\"";
  print "fs = require(\"fs\")";
  print "data = {";
  for (i in all) {
    print "  \"" i "\": {";
    print "    \"total\": " days[i] ",";
    print "    \"versions\": {";
    for (j in all[i]) {
      print "      \"" j "\": " all[i][j] ",";
    } 
    print "      \"_\": \"\"";
    print "    }";
    print "  },";
  }
  print "  \"_\": \"\"";
  print "}";
  print "dates = Object.keys(data).sort().filter(function (date) { return date != \"_\" })";
  # strip off the first and last days to avoid overlaps between runs
  print "dates = dates.slice(1, dates.length - 1)";
  print "stats = {}";
  print "try { stats = require(statfile) } catch (e) {}";
  print "dates.forEach(function (date) {";
  print "  var ds = new Date(date).toISOString().substring(0, 10)";
  print "  stats[ds] = { total: data[date].total, versions: data[date].versions }";
  print "  delete stats[ds].versions._";
  print "})";
  print "fs.writeFileSync(statfile, JSON.stringify(stats, null, 2), \"utf8\")";
}

' $outfile | node
