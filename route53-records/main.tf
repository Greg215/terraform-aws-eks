# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE DNS ENTRIES USING ROUTE53
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Simple Records like A, CNAME etc.
resource "aws_route53_record" "records" {
  count = length(var.records)

  zone_id = var.zone_id
  type    = var.type
  name    = var.records[count.index]["NAME"]
  ttl     = var.records[count.index]["TTL"]
  records = compact(split(",", var.records[count.index]["RECORD"]))
}

# Weighted Resources
resource "aws_route53_record" "weighted" {
  count = length(var.records_with_weight)

  zone_id = var.zone_id
  type    = var.type
  name    = var.records_with_weight[count.index]["NAME"]
  ttl     = var.records_with_weight[count.index]["TTL"]

  weighted_routing_policy {
    weight = var.records_with_weight[count.index]["WEIGHT"]
  }

  set_identifier = var.records_with_weight[count.index]["SID"]

  health_check_id = lookup(var.records_with_weight[count.index], "HEALTH_CHECK_ID", "")

  records = compact(split(",", var.records_with_weight[count.index]["RECORD"]))
}

# Resources with Alias
resource "aws_route53_record" "Alias" {
  count = length(var.records_with_alias)

  zone_id = var.zone_id
  type    = var.type
  name    = var.records_with_alias[count.index]["NAME"]

  alias {
    name                   = var.records_with_alias[count.index]["RECORD"]
    zone_id                = var.records_with_alias[count.index]["ZONE_ID"]
    evaluate_target_health = var.records_with_alias[count.index]["EVALUATE_TARGET_HEALTH"]
  }
}

#  Weighted Resources with Aliases
resource "aws_route53_record" "Alias-Weighted" {
  count = length(var.records_with_alias_weight)

  zone_id = var.zone_id
  type    = var.type
  name    = var.records_with_alias_weight[count.index]["NAME"]

  weighted_routing_policy {
    weight = var.records_with_alias_weight[count.index]["WEIGHT"]
  }

  set_identifier = var.records_with_alias_weight[count.index]["SID"]

  alias {
    name                   = var.records_with_alias_weight[count.index]["RECORD"]
    zone_id                = var.records_with_alias_weight[count.index]["ZONE_ID"]
    evaluate_target_health = var.records_with_alias_weight[count.index]["EVALUATE_TARGET_HEALTH"]
  }
}
