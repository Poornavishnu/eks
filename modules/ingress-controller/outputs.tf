# output "ingress_controller_dns" {
#   description = "Ingress Controller LoadBalancer DNS (wait a few mins)"
#   value       = try(
#     helm_release.nginx_ingress.status[0].load_balancer[0].ingress[0].hostname,
#     "pending: not ready yet"
#   )
# }