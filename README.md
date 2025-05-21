# Cloudflare Standard Module

This module provides a standard way to set up a CloudFlare DNS Zone with WAF rules, Rate limiting and Cache configs.

## Target
For use by platform team that wants to provide a uniform way to provision CF resources within an organization where other teams can use Terraform to create CF resources by themselves.

## Design Principle
1. Tenants’ configuration are isolated to reduce radius blast.
2. Single entrypoint module for ease of consumption by other teams.
3. Capabilities for providing defaults.

## Implementation note
1. Design principle #1: Segregate on Zone level because other teams do not need admin access to CF and zone being the finest level that rules apply. Another implementation detail is that [CF Custom Lists](https://developers.cloudflare.com/waf/tools/lists/custom-lists/) (usually used to define sets of IPs to whitelist in CF WAF) should not be used because it is an [Account-scoped resource](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/list). Therefore, [IP addresses are specified directly in the ruleset](https://github.com/minhtrietbkit/cloudflare-standard-module/blob/2dbf106518b7606e2185b3b6fae5d6b338fb70dc/main.tf#L36C34-L36C79).
1. Design principle #2: Each concern (DNS, WAF, rate limiting, cache config) can be in its own submodule for ease of management if they are complicated enough.
1. Design principle #3: If submodules are used, defaults should be defined in according submodule to completely isolate concern and reduce radius blast (main module only bumps up specific submodule version, no changes)
 
## Input
Minimal inputs are `dns_a_record_list` and `zone_name`. See [.tfvar](.tfvars) for a concrete example.

