variable "zone_name" {
  type = string
  description = "The CF zone name to work with"
}

variable "dns_a_record_list" {
  type = map(object({
    comment = string
    content = string
    proxied = bool
  }))
  description = "List of DNS names to setup on this CF zone in the format of name: {record-config}"
}

variable "ip_allowlist" {
  type = list(string)
  description = "List of IP addresses to be whitelisted by CF"
}

variable "flag_enable_allow_list" {
  type = bool
  description = "Whitelist only IP addresses in IP allowlist. False means site is available to all IP addresses"
}

variable "flag_enable_rate_limit" {
  type = bool
  description = "Enable rate limit rules"
}

variable "flag_enable_cache_config" {
  type = bool
  description = "Enable cache configuration rules"
}

variable "rate_limit_rule_list" {
  type = list(object({
    description         = string
    expression          = string
    period              = number
    requests_per_period = number
    mitigation_timeout  = number
  }))
  description = "List of rate limiting config"
}

variable "cache_rule_list" {
  type = list(object({
    description = string
    expression  = string
    serve_stale = bool
    edge_ttl    = number
    cache_key = object({
      cache_by_country     = bool
      cache_by_device_type = bool
      cache_by_language    = bool
    })
  }))
  description = "List of cache rules"
}