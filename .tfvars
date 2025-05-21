zone_name = "triettran.uk"
dns_a_record_list = {
  #. denotes the zone apex. In this example, it's triettran.uk
  "." = {
    comment = "apex record, points to GCP CE"
    content = "34.136.99.74"
    proxied = true
  }
  # this configures DNS name saas.triettran.uk
  "saas" = {
    comment = "points to GCP CE"
    content = "34.136.99.74"
    proxied = true
  }
}

ip_allowlist = [
    "76.112.244.253/32",
]

rate_limit_rule_list = [
  {
    description = "Rate limit API requests by IP"
    expression = "true"
    period = 10
    requests_per_period = 30
    mitigation_timeout = 10
  }
]

cache_rule_list = [
  {
    description: "Cache rule for all requests"
    expression: "true",
    serve_stale: false,
    edge_ttl: 60,
    cache_key:{
      cache_by_country: true,
      cache_by_device_type: true,
      cache_by_language: true
    }
  }]

flag_enable_rate_limit = true
flag_enable_allow_list = true #false means open to all IP addresses
flag_enable_cache_config = true
