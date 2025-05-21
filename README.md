# Cloudflare Standard Module

This module provides a standard way to set up a CloudFlare DNS Zone with WAF rules, Rate limiting and Cache configs.

## Target
For use by platform team that wants to provide a uniform way to provision CF resources within an organization where other teams can use Terraform to create CF resources by themselves.

## Features

* Isolate on zone levels for reducing radius blast: efforts are made to use Zone scoped resources instead of Account scoped resources - CF Custom Lists (usually used to define sets of IPs to whitelist in CF WAF) is not used, IP addresses are specified directly as part of the ruleset.
* Enforce default values: Platform team can enforce default values by updating [default lists in locals section](https://github.com/minhtrietbkit/cloudflare-standard-module/blob/41c441f83e0f4619be8a46b02be93ff79a89ad66/main.tf#L3-L5).

## Input
Minimal inputs are `dns_a_record_list` and `zone_name`. See [.tfvar](.tfvars) for a concrete example.

