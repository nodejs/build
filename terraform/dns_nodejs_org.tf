resource "cloudflare_record" "terraform_managed_resource_1e97b7a84f994af9aedcd252c8aae198" {
  name    = "ansible"
  proxied = true
  ttl     = 1
  type    = "A"
  value   = "169.60.150.91"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_7c7bed12d0273b7070ce212326104faf" {
  name    = "ci"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "107.170.240.62"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_a8cdda4611ecd58b2e2269179aa392db" {
  name    = "ci-release"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "169.45.166.50"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_6b6c1fea957ef35dc91387d697108c7d" {
  name    = "direct"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "138.197.224.240"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_2c267a0a7b259ec0168a385619af14b2" {
  name    = "github-bot"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "23.253.100.79"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_7797ebb76f7797762d5d6a41a2c97400" {
  name    = "grafana"
  proxied = true
  ttl     = 1
  type    = "A"
  value   = "147.28.162.110"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_517b225ac142ebb3eddf06a06a5ede8a" {
  name    = "gzemnid"
  proxied = true
  ttl     = 1
  type    = "A"
  value   = "178.128.202.158"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_4202d23997f33464f0a290760badf99b" {
  name    = "memtest"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "172.99.112.140"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_6ee190392452894868200725c55beef5" {
  name    = "triage"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "72.2.118.51"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_edec9009e8b3d5280c7c08f83b5b06f6" {
  name    = "unencrypted"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "147.28.162.105"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_62a1a70e9a6664053272850dd38cfa23" {
  name    = "unofficial-builds"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "45.55.98.129"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_39362d1838ae02ce3c212d8cf1d122a5" {
  name    = "nodejs.org"
  proxied = true
  ttl     = 1
  type    = "AAAA"
  value   = "2604:a880:400:d1::a3c:f001"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_b92bb39ac8d8a7fe1f60f295ae4e6f3c" {
  name    = "_2ad3ed9cacf2d25d5224d04db1a4d677"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "2fb3dc900f0968bd883ee25a88024c39.45e0122a0374b8b09f485b2d239c01b7.e16c1c41bcd4c7842b.sectigo.com"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_475548ad57e9d2b01393a7e543231148" {
  name    = "_c44b831a22ab9039953536a5fbf41513"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "e7e4215c01a2775a2d2fd7b799eeb963.8d7d7eb200163a2107dc4d4505aa08ba.fa3ed62adf396f9275.sectigo.com"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_6ab233c3c1b231e6bb576df49cd80e8e" {
  name    = "_c9ef34ab7f60f3e351aaeaa158a3553c"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "c2b1a295cdb3f1c5cfa03d1bc7c6b598.0ef9b3ba802051f61c70bc3080ec968f.w0834777001502709292.comodoca.com"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_b5355dea1fae185149c7c970ef36c74e" {
  name    = "coverage"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "nodejs.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_e23716010539dc90edf5667f022f1fee" {
  name    = "foundation"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "nodejs.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_fafc41f07e8294ec9bc6dc4b7e46c976" {
  name    = "interactive"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "nodejs.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_7ee0bf83cdbf7c81f1474ad30e474e3c" {
  name    = "live"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "nodejs.github.io"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_e7385cf24ad8660f929ad64132c56c72" {
  name    = "logs"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "logs.libuv.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_d0dbc6d7694d2445b23e84f5fdc8e6cd" {
  name    = "modules"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "npmjs.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_d02089a550d282c5c3037779e62873c9" {
  name    = "new"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "nodejs.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_b50357bffb69a1e3a67de31e4184a837" {
  name    = "*"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "nodejs.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_e30d4a05a180489fa391d40baee0b95c" {
  name    = "packages"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "npmjs.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_40b8fc17985cdefb1730c4e32916c4eb" {
  name    = "status"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "rxy2rhgm8q1n.stspg-customer.com"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_ca0756f747cbb829018cd96d0a1287bf" {
  name    = "store"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "node-js-community-store.myshopify.com"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_c15ad1f5dcab7b626a6877ce0f823423" {
  name    = "training"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "portal.linuxfoundation.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_2ba0078ee97347649b6f03fbcb1d4ef4" {
  name    = "undici"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "nodejs.github.io"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_583eb882748918e06b43cf75c71761e0" {
  comment = "Experiment with Node.js Website Traffic on Vercel: https://github.com/nodejs/build/issues/3366"
  name    = "vercel"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "cname.vercel-dns.com"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_ded591b2162b27b8c835337efc8cd515" {
  name    = "www"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "nodejs.org"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_effe3c060a29ec6eceb27b89169d42bf" {
  name     = "nodejs.org"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "alt2.aspmx.l.google.com"
  zone_id  = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_6b72eff173bb573f8818835195a3355d" {
  name     = "nodejs.org"
  priority = 20
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "alt1.aspmx.l.google.com"
  zone_id  = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_270db44c46f250a5e83b8b1fbc7ccbe4" {
  name     = "nodejs.org"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "aspmx.l.google.com"
  zone_id  = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_5d46bf1555ccf32c1c2d65e8e2db341c" {
  name     = "nodejs.org"
  priority = 30
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "aspmx3.googlemail.com"
  zone_id  = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_6918f98540583233f3d7b54eb663d34f" {
  name     = "nodejs.org"
  priority = 30
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "aspmx2.googlemail.com"
  zone_id  = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_965e11dce32697ad7fe24ebd0c1af8f4" {
  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=DMARC1; p=reject; rua=mailto:build@iojs.org; ruf=mailto:build@iojs.org; sp=reject; ri=86400"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_3ec027a6661a695ab2e286fc996edda3" {
  name    = "_github-challenge-nodejs"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "225c7d79d9"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

resource "cloudflare_record" "terraform_managed_resource_56098fab3ccae56775e6e9b52ce2794b" {
  name    = "nodejs.org"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=spf1 include:aspmx.googlemail.com -all"
  zone_id = "1206c4f949d69993ae55d9d015804406"
}

