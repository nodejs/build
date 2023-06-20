resource "cloudflare_record" "terraform_managed_resource_1913231cd4f209515037c1ffee5d4a27" {
  name    = "direct"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "138.197.224.240"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_0f6b6757054fdba56c054cca6aecc9be" {
  name    = "iojs.org"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "138.197.224.240"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_3e025abdebca0ae6576a71a2c26d2c1b" {
  name    = "www"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = "138.197.224.240"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_b33f8bbe47906fef181a1592437fd95a" {
  name    = "iojs.org"
  proxied = true
  ttl     = 1
  type    = "AAAA"
  value   = "2604:a880:400:d1::a3c:f001"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_f356629b68819fd225bdd3394c12b560" {
  name    = "www"
  proxied = true
  ttl     = 1
  type    = "AAAA"
  value   = "2604:a880:400:d1::a3c:f001"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_bddb08d52eb2227d0dc3e4f7ce056c8b" {
  name    = "_19b4f8a51243a804259af6d5b2490cbf"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "0fa21492b60cd77cef88dd04e54a6c9b.d5ddcd1a90d12402e4751fb51f52d610.w0936042001502710049.comodoca.com"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_ddd771da56ee034b1d3203b2c67bbfeb" {
  name    = "email.iojs.org"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "mailgun.org"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_1aad4db1f51e00a30cb1d81e5150e32c" {
  name    = "logos"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "iojs.org"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_a78309035efe195a7a2607c3f52e7f15" {
  name    = "new-nodejs"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "www.iojs.org"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_e146702ef04508a564c99f69e84e78e7" {
  name    = "roadmap"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  value   = "iojs.org"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_78ef7407c3d14a5c679084b035abe76b" {
  name     = "iojs.org"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "mxb.mailgun.org"
  zone_id  = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_73d56ede702145a55657302ed70a4def" {
  name     = "iojs.org"
  priority = 10
  proxied  = false
  ttl      = 1
  type     = "MX"
  value    = "mxa.mailgun.org"
  zone_id  = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_fe6cb302ca689b99a71a55c503ddba72" {
  name    = "_dmarc"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "v=DMARC1; p=reject; rua=mailto:build@iojs.org; ruf=mailto:build@iojs.org; sp=reject; ri=86400"
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_a586614f723184920a970d2967a5b0f8" {
  name    = "iojs.org"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "\"google-site-verification=sLdkuluh-xi3YZs_Uhobiw1XA_Wjalt8D8O_2jiwudg\""
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_1d4e8509d885efb04761863b0493cbfc" {
  name    = "iojs.org"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "\"v=spf1 include:mailgun.org ~all\""
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

resource "cloudflare_record" "terraform_managed_resource_8966613ab75b29a56f3c787f8bb10e56" {
  name    = "mailo._domainkey"
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "\"k=rsa\\; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDBvSPBv8CLasvSnADi672NJNMa2hK0CTuTIpzCLIz1hfZKcFybimLDvMGFTAhxG3SnQOT9Torm4Ep16kIxjl6c2ms1fmoZr7e0iia4l45vO0/mYs3sZJIOlGDh1r0Vwr6aOB5eJL3D41+HPfdw236mTX+v+W6swQNCHrlXZeIoTQIDAQAB\""
  zone_id = "8c96c2859d246364a9b78b2fee7bee49"
}

