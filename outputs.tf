output "zone" {
  value = data.cloudflare_zones.this.result[0].id
}

output "waf_ruleset_id" {
  value = var.flag_enable_allow_list ? cloudflare_ruleset.waf_ruleset[0].id : ""
}
output "ratelimit_ruleset_id" {
  value = var.flag_enable_rate_limit ? cloudflare_ruleset.ratelimit_ruleset[0].id : ""
}
output "cache_ruleset_id" {
  value = var.flag_enable_cache_config ? cloudflare_ruleset.cache_ruleset[0].id : ""
}
