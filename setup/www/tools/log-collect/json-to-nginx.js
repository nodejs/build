#!/usr/bin/env node

// log_format nodejs    '$remote_addr - $remote_user [$time_local] '
//                     '"$request" $status $body_bytes_sent '
//                     '"$http_referer" "$http_user_agent" "$http_x_forwarded_for"';
//0.0.0.0 - - [14/Apr/2017:09:25:15 +0000] "GET /en/docs/es6/ HTTP/1.1" 200 4285 "https://www.google.com/" "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/0.0.0.0 Safari/537.36" "0.0.0.0"

//{"brandId":100,"flags":2,"hosterId":0,"ownerId":2598267,"rayId":"34f5210c4b2f0b56","securityLevel":"eoff","timestamp":1492156801968000000,"unstable":null,"zoneId":15832072,"zoneName":"nodejs.org","zonePlan":"business","cache":{"bckType":"byc","cacheExternalIp":"0.0.0.0","cacheExternalPort":26380,"cacheFileKey":null,"cacheInternalIp":"0.0.0.0","cacheServerName":"22c24","cacheStatus":"unknown","cacheTokens":0,"endTimestamp":1492156803756000000,"startTimestamp":1492156801971000000},"cacheRequest":{"headers":null,"keepaliveStatus":"noReuseOpenFailed"},"cacheResponse":{"bodyBytes":0,"bytes":476907,"contentType":"application/gzip","retriedStatus":0,"status":200},"client":{"asNum":16509,"country":"jp","deviceType":"desktop","ip":"0.0.0.0","ipClass":"noRecord","srcPort":42727,"sslCipher":"ECDHE-RSA-AES128-GCM-SHA256","sslFlags":1,"sslProtocol":"TLSv1.2"},"clientRequest":{"accept":"","body":null,"bodyBytes":0,"bytes":1056,"cookies":null,"flags":0,"headers":[],"httpHost":"nodejs.org","httpMethod":"GET","httpProtocol":"HTTP/1.1","referer":"","uri":"/download/release/v6.9.2/node-v6.9.2-headers.tar.gz","userAgent":"node-gyp v3.4.0 (node v6.9.2)"},"edge":{"bbResult":"0","cacheResponseTime":2775000000,"colo":22,"enabledFlags":8,"endTimestamp":1492156804744000000,"flServerIp":"0.0.0.0","flServerName":"22f20","flServerPort":443,"pathingOp":"wl","pathingSrc":"macro","pathingStatus":"nr","startTimestamp":1492156801968000000,"usedFlags":0,"rateLimit":{"ruleId":0,"mitigationId":null,"sourceId":"","processedRules":null},"dnsResponse":{"rcode":0,"error":"ok","cached":true,"duration":0,"errorMsg":"","overrideError":false}},"edgeRequest":{"bodyBytes":0,"bytes":1857,"headers":null,"httpHost":"nodejs.org","httpMethod":"GET","keepaliveStatus":"reuseAccepted","uri":"/download/release/v6.9.2/node-v6.9.2-headers.tar.gz"},"edgeResponse":{"bodyBytes":476907,"bytes":477355,"compressionRatio":0,"contentType":"application/gzip","headers":null,"setCookies":null,"status":200},"origin":{"asNum":46652,"ip":"0.0.0.0","port":443,"responseTime":0,"sslCipher":"UNK","sslProtocol":"unknown"},"originResponse":{"bodyBytes":0,"bytes":0,"flags":0,"headers":[],"httpExpires":0,"httpLastModified":1481052127000000000,"status":200}}

const through2  = require('through2')
    , split2    = require('split2')
    , strftime  = require('strftime').timezone(0)
    , timefmt   = '%e/%b/%Y:%H:%M:%S +0000'


const jsonify = through2.obj(function jsonifyLine (chunk, enc, callback) {
  let data = null
  try {
    data = JSON.parse(chunk)
  } catch (e) {}
  callback(null, data)
})


const transform = through2.obj(function transformLine (chunk, enc, callback) {
  let remote_addr = chunk.client.ip
    , country     = chunk.client.country
    , remote_user = '-'
    , time_local  = strftime(timefmt, new Date(chunk.timestamp / 1000000))
    , request     = `${chunk.clientRequest.httpMethod} ${chunk.clientRequest.uri} ${chunk.clientRequest.httpProtocol}`
    , status      = chunk.edgeResponse.status
    , body_bytes_sent = chunk.edgeResponse.bodyBytes
    , http_referer    = chunk.clientRequest.referer.replace(/"/g, '\\"')
    , http_user_agent = chunk.clientRequest.userAgent.replace(/"/g, '\\"')
    , http_x_forwarded_for = remote_addr

  callback(null, `${remote_addr} ${country} ${remote_user} [${time_local}] "${request}" ${status} ${body_bytes_sent} "${http_referer}" "${http_user_agent}" "${http_x_forwarded_for}"\n`)
})


process.stdin
  .pipe(split2())
  .pipe(jsonify)
  .pipe(transform)
  .pipe(process.stdout)

