data "http" "ipv4" {
  url = "http://ipv4.icanhazip.com"
}

# Record which will be updated by DDNS
resource "cloudflare_record" "apex_ipv4" {
  name    = "ipv4"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = chomp(data.http.ipv4.response_body)
  proxied = true
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "cname_root" {
  name    = data.sops_file.cloudflare_secrets.data["domain"]
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = "ipv4.${data.sops_file.cloudflare_secrets.data["domain"]}"
  proxied = true
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "cname_wireguard" {
  name    = "vpn"
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  value   = "ipv4.${data.sops_file.cloudflare_secrets.data["domain"]}"
  proxied = false
  type    = "CNAME"
  ttl     = 1
}
