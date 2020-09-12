output "nginx_ingress_hostname" {
  value = data.kubernetes_service.nginx_service_aws_nlb.load_balancer_ingress.0.hostname
  description = "NGINX Ingress Hostname"
}

output "nginx_ingress_ip" {
  value = data.kubernetes_service.nginx_service_aws_nlb.load_balancer_ingress.0.ip
  description = "NGINX Ingress IP Address"
}

output "nginx_nlb_zone_id" {
  value = data.aws_lb.nginx_nlb.zone_id
  description = "Zone ID of Network Load balancerd deployed by NGINX service"
}