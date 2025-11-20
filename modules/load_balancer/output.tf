output "module_alb_id" {
  value = var.create_resource["load_balance"] ? aws_lb.alb.id : null
}