# requires "inputdir" and "outputfile"

sourcename = "nodejs.org"
countrycolumns = system("awk -F, 'NR == 1 { print NF; exit }' " . inputdir . "/country.csv")
versioncolumns = system("awk -F, 'NR == 1 { print NF; exit }' " . inputdir . "/version.csv")
archcolumns  = system("awk -F, 'NR == 1 { print NF; exit }' " . inputdir . "/arch.csv")
oscolumns  = system("awk -F, 'NR == 1 { print NF; exit }' " . inputdir . "/os.csv")

set macros
LABELSETTINGS = "at graph 0.01,0.96 font 'Ubuntu Mono,14' textcolor rgb \"#9999a5\""

set linetype 1  lc rgb "#E41A1C" lw 1
set linetype 2  lc rgb "#377EB8" lw 1
set linetype 3  lc rgb "#4DAF4A" lw 1
set linetype 4  lc rgb "#984EA3" lw 1
set linetype 5  lc rgb "#FF7F00" lw 1
set linetype 6  lc rgb "#D0D033" lw 1
set linetype 7  lc rgb "#A65628" lw 1
set linetype 8  lc rgb "#F781BF" lw 1
set linetype cycle 8

set datafile sep ","

countrysums = ""
do for [i = 2:countrycolumns] {
   stats inputdir . "/country.csv" using i nooutput
   countrysums = countrysums . " " . int(STATS_sum)
}
versionsums = ""
do for [i = 2:versioncolumns] {
   stats inputdir . "/version.csv" using i nooutput
   versionsums = versionsums . " " . int(STATS_sum)
}
ossums = ""
do for [i = 2:oscolumns] {
   stats inputdir . "/os.csv" using i nooutput
   ossums = ossums . " " . int(STATS_sum)
}
archsums = ""
do for [i = 2:archcolumns] {
   stats inputdir . "/arch.csv" using i nooutput
   archsums = archsums . " " . int(STATS_sum)
}
stats inputdir . "/total.csv" using 2 nooutput
totalsum = int(STATS_sum)
stats inputdir . "/total.csv" using 3 nooutput
totalbytes = int(STATS_sum)

set timefmt "%Y-%m-%d"
set format x "%b-%Y"
set xdata time
set style data lines
set key tc variable

#set xrange ["2015-01-01" < * :]
#set yrange [0 < * < 0:25000]

set border lc rgb "#dddde5"
set xtics textcolor rgb "#9999a5"
set ytics textcolor rgb "#9999a5"

set term pngcairo size 2000,800 font "Ubuntu Mono,11" background rgb "#fefeff"

set output outputdir . "/country.png"
set label 1 "Top Countries (" . sourcename . ")" @LABELSETTINGS
plot for [i=2:11] inputdir . "/country.csv" every ::1 \
  using 1:i title sprintf(system("head -1 " . inputdir . "/country.csv | awk -F, '{ print $".i." }'")." / day (total: %'dk)", word(countrysums, i-1) / 1000) lw 2

set output outputdir . "/version.png"
set label 1 "Node.js Versions (" . sourcename . ")" @LABELSETTINGS
plot for [i=2:versioncolumns] inputdir . "/version.csv" every ::1 \
  using 1:i title sprintf(system("head -1 " . inputdir . "/version.csv | awk -F, '{ print $".i." }'")." / day (total: %'dk)", word(versionsums, i-1) / 1000) lw 2

set output outputdir . "/os.png"
set label 1 "Operating Systems (" . sourcename . ")" @LABELSETTINGS
plot for [i=2:oscolumns] inputdir . "/os.csv" every ::1 \
  using 1:i title sprintf(system("head -1 " . inputdir . "/os.csv | awk -F, '{ print $".i." }'")." / day (total: %'dk)", word(ossums, i-1) / 1000) lw 2

set output outputdir . "/arch.png"
set label 1 "Architectures (" . sourcename . ")" @LABELSETTINGS
plot for [i=2:archcolumns] inputdir . "/arch.csv" every ::1 \
  using 1:i title sprintf(system("head -1 " . inputdir . "/arch.csv | awk -F, '{ print $".i." }'")." / day (total: %'dk)", word(archsums, i-1) / 1000) lw 2

set output outputdir . "/total.png"
set ytics textcolor rgb "#E41A1C"
set y2tics textcolor rgb "#377EB8"
set label 1 "Total downloads (" . sourcename . ")" @LABELSETTINGS
plot inputdir . "/total.csv" every ::1 \
  using 1:2 title sprintf("Downloads per day (total: %'dk)", totalsum / 1000) lw 2, \
  "" using 1:($3 * 1024) title sprintf("MiB per day (total: %'d TiB)", totalbytes) lw 2 axes x1y2

