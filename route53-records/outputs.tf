output "records_name" {
  value = aws_route53_record.records.*.name
}

output "records_id" {
  value = aws_route53_record.records.*.name
}

output "weighted_resources_name" {
  value = aws_route53_record.weighted.*.name
}

output "alias_name" {
  value = aws_route53_record.Alias.*.name
}

output "weighted_alias_name" {
  value = aws_route53_record.Alias-Weighted.*.name
}
