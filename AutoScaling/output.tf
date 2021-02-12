output "this_elb_dns_name" {
  description = "DNS Name of the ELB"
  value       = module.elb.this_elb_dns_name
}
