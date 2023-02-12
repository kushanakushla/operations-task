output "load_balancer_url" {
  description = "Load Balancer URL"
  value       = module.alb.alb.dns_name
}
