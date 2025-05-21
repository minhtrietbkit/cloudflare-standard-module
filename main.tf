locals {
  zone_id = data.cloudflare_zones.this.result[0].id
  default_ip_allowlist = ["196.168.0.0/18", "10.0.0.0/16"]
  default_rate_limit_rule_list = []
  default_cache_rule_list = []

  effective_ip_allowlist = var.flag_enable_allow_list ? concat(local.default_ip_allowlist, var.ip_allowlist) : local.default_ip_allowlist
  effective_rate_limit_rule_list = var.flag_enable_rate_limit ? concat(local.default_rate_limit_rule_list, var.rate_limit_rule_list) : local.default_rate_limit_rule_list
  effective_cache_rule_list = var.flag_enable_cache_config ? concat(local.default_cache_rule_list, var.cache_rule_list) : local.default_cache_rule_list
}

## DNS
resource "cloudflare_dns_record" "this" {
  zone_id = local.zone_id
  for_each = var.dns_a_record_list
  comment = each.value.comment
  content = each.value.content
  name = each.key == "." ? var.zone_name : "${each.key}.${var.zone_name}"
  proxied = each.value.proxied
  ttl = 1
  type = "A"
}

## WAF
resource "cloudflare_ruleset" "waf_ruleset" {
  count = length(local.effective_ip_allowlist) > 0 ? 1 : 0
  kind = "zone"
  name = "IP Allow List for zone ${var.zone_name}"
  phase = "http_request_firewall_custom"
  zone_id = local.zone_id
  description = "WAF rules to allow only connections from IP address allow list for zone ${var.zone_name}"
  rules = [{
    action = "block"
    description = "Block when the IP address is not in the allow list"
    enabled = true
    expression = "(not ip.src in {${join(" ", local.effective_ip_allowlist)}})"
  }]
}

## Rate Limit
resource "cloudflare_ruleset" "ratelimit_ruleset" {
  count = length(local.effective_rate_limit_rule_list) > 0 ? 1 : 0
  zone_id     = local.zone_id
  name        = "Rate limiting for zone ${var.zone_name}"
  description = "Rate limiting for zone ${var.zone_name}"
  kind        = "zone"
  phase       = "http_ratelimit"

  rules = [for r in local.effective_rate_limit_rule_list: {
    description = r.description
    expression  = r.expression
    action      = "block"
    ratelimit = {
      characteristics = ["cf.colo.id", "ip.src"]
      period = r.period
      requests_per_period = r.requests_per_period
      mitigation_timeout = r.mitigation_timeout
    }
  }]
}

## Cache
resource "cloudflare_ruleset" "cache_ruleset" {
  count = length(local.effective_cache_rule_list) > 0 ? 1 : 0
  zone_id     = local.zone_id
  name        = "Cache rules for zone ${var.zone_name}"
  description = "Cache rules for zone ${var.zone_name}"
  kind        = "zone"
  phase       = "http_request_cache_settings"

  rules = [for r in local.effective_cache_rule_list:
    {
      description = r.description
      enabled = true
      expression  = r.expression
      action      = "set_cache_settings"
      action_parameters = {
        serve_stale = {
          disable_stale_while_updating = !r.serve_stale
        }
        edge_ttl = {
          mode = "override_origin",
          default = r.edge_ttl
        }
        cache_key = {
          ignore_query_strings_order = true
          cache_deception_armor      = true
        }
        custom_key = {
          user = {
            device_type = r.cache_key.cache_by_device_type
            geo         = r.cache_key.cache_by_country
            lang = r.cache_key.cache_by_language
          }
        }
      }
    }
  ]
}
