output "frontend-url" {
  value = "http://${var.hostname}.${var.hosted-zone-name}"
}
