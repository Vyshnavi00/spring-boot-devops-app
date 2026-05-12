output "alb_dns_name" {
  description = "URL to access the application"
  value       = aws_lb.main.dns_name
}
