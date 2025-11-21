output "module_alb_id" {
  value = var.create_resource["load_balance"] ? aws_lb.alb[0].id : null
}