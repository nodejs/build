BEGIN {
  # Utility array to convert logfile month names to month numbers
  split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec", month)
  for (i in month) {
    month_nums[month[i]] = (i / 1 >= 10 ? "" : "0") i
  }
  fmt = "%s,%s,%s,%s,%s,%s,%s\n"
  printf fmt, "ip", "day", "path", "version", "os", "arch", "bytes"
}

(!($6 == "\"GET" || $6 == "GET")) { next } # non-GET requests

($10 < 1000) { next } # unreasonably small download

!/\.(tar\.gz|tar\.xz|pkg|msi|exe|zip|7z)(\?[^ ]+)? HTTP\/[12]\.[10][" ]/ {
  #print "Skipping:", $0
  #check we're not missing anything with: grep Skipping /tmp/_var_log_nginx_nodejs.org-access.log | awk '{print $10 $8}'| grep -v '/$\|html$\|png$\|svg$\|json\|jpg$\|xml$\|txt$\|jar$\|js$\|pom$\|css$\|ico$\|zip$\|lib$\|exp$\|^40\|^30\|tab$\|eps$\|asc$\|gpg$\|pdf$\|tgz$\|\?\|\#\|pdb$\|rtf$\|md$\|SHASUMS'
  next
}

{ gsub("\"", "", $9) }

($9 < 200 || $9 > 300) { next } # status code not ~200

{
  success = match($0, \
      / \[([^:]+).* "?GET (\/+(dist|download\/+release)\/+(node-latest\.tar\.gz|([^/]+)\/+((win-x64|win-x86|win-arm64|x64)?\/+?node\.exe|(x64\/)?node-+(v[0-9\.]+)[\-\.]([^\? ]+))))(\?[^ ]+)? HTTP\/[12]\.[01][" ]/ \
    , m \
  )

  if (success) {
    date = m[1]
    day = substr(date, 8, 4) "-" month_nums[substr(date, 4, 3)] "-" substr(date, 1, 2)

    path = m[2]
    #m[3]=root
    #latestSrc = (m[4] == "node-latest.tar.gz")
    pathVersion = m[5]
    file = m[6]
    winArch = m[7]
    #m[8]=x64/?

    # version can come from the filename or the path, filename is best
    # but it may not be there (e.g. node.exe) so fall back to path version
    fileVersion = m[9]
    if (match(fileVersion, /^v[0-9\.]+$/)) {
      version = fileVersion
    } else if (match(pathVersion, /^v[0-9\.]+$/)) {
      version = pathVersion
    } else {
      version = ""
    }

    fileType = m[10]
    #m[11]=query string
    #m[12]=ip including quotes

    if (match(fileType, /^headers\.tar\..z$/)) {
      os = "headers"
    } else if (match(fileType, /^linux-/)) {
      os = "linux"
    } else if (fileType == "pkg" || match(fileType, /^darwin-/)) {
      os = "osx"
    } else if (match(fileType, /^sunos-/)) {
      os = "sunos"
    } else if (match(fileType, /^aix-/)) {
      os = "aix"
    } else if (match(fileType, /msi$/) || match(file, /node\.exe$/) || match(fileType, /^win-/)) {
      os = "win"
    } else if (match(fileType, /^tar\..z$/) || match(path, /\/node-latest\.tar\.gz$/)) {
      os = "src"
    } else {
      os = ""
    }

    if (index(fileType, "x64") > 0 || fileType == "pkg") {
      # .pkg for Node.js <= 0.12 were universal so may be used for either x64 or x86
      arch = "x64"
    } else if (index(fileType, "x86") > 0) {
      arch = "x86"
    } else if (index(fileType, "armv6") > 0) {
      arch = "armv6l"
    } else if (index(fileType, "armv7") > 0) { # 4.1.0 had a misnamed binary, no "l" in "armv7l"
      arch = "armv7l"
    } else if (index(fileType, "arm64") > 0) {
      arch = "arm64"
    } else if (index(fileType, "ppc64le") > 0) {
      arch = "ppc64le"
    } else if (index(fileType, "ppc64") > 0) {
      arch = "ppc64"
    } else if (index(fileType, "s390x") > 0) {
      arch = "s390x"
    } else if (os == "win") {
      # we get here for older .msi files and node.exe files
      if (index(winArch, "x64") > 0) {
        # could be "x64" or "win-x64"
        arch = "x64"
      } else {
        # could be "win-x86" or ""
        arch = "x86"
      }
    } else {
      arch = ""
    }

    bytes = $10

    # IP address is tricky, it should be (but may not be in some logs) the last quoted field in the
    # log but because of awk's greed regexes and unpredictable user-agent strings we can't build
    # it into the main regex above, so we re-split the line by quotes and check the final string.
    # The field comes from X-Forwarded-For and can contain any number of comma-separated (possibly
    # with space characters too) IPv4 or IPv6 addresses, or "unknown" (non-standard but it shows
    # up. To get the most likely usable IP address closest to the user we have to find the left-most
    # valid, _public_ address in the list.
    quotl = split($0, quots, "\"")
    ipfield = quots[quotl - 1]
    ipmatch = match(ipfield, /^(([0-9a-f:\.]+|unknown)([ ,])*)+$/)
    if (ipmatch) {
      gsub(/\s/, "", ipfield) # strip spaces
      ipc = split(ipfield, ips, ",")
      if (ipc == 1) { # just one address, yay
        ip = ipfield
      } else {
        ip = ""
        for (i = 1; i <= ipc; i++) {
          # find first valid, non-private IP address
          if (match(ips[i], /^[0-9a-f:\.]+$/) && !match(ips[i], /(^127\.)|(^192\.168\.)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^::1$)|(^[fF][cCdD])/)) {
            ip = ips[i]
            break
          }
        }
      }
    } else if (ipfield == "-") { # probably old log file, use direct ip instead
      ip = $1
    } else {
      ip = ""
    }

    printf fmt, ip, day, path, version, os, arch, bytes
  #} else {
    #print "WARNING: Could not parse line " NR " [" $0 "]" > "/dev/stderr"
  }
}
