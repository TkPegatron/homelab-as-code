resource "cloudflare_page_rule" "jellyfin_bypass_cache" {
  zone_id = lookup(data.cloudflare_zones.domain.zones[0], "id")
  target  = "jellyfin.${data.sops_file.cloudflare_secrets.data["domain"]}/*"
  status  = "active"

  actions {
    cache_level = "bypass"
  }
}
