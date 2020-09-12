data "kubectl_path_documents" "k8_app1" {
  pattern = "./k8/*.yaml"
  vars = {
    javaapp_docker_image_prefix = "devopstraining143"
    eks_cluster_name            = local.cluster_id
  }
}

resource "kubectl_manifest" "k8_app1_deploy" {
  depends_on = [ data.kubectl_path_documents.k8_app1 ]

  count     = length(data.kubectl_path_documents.k8_app1.documents)
  yaml_body = element(data.kubectl_path_documents.k8_app1.documents, count.index)
}

data "kubernetes_service" "nginx_service_aws_nlb" {
  depends_on = [ kubectl_manifest.k8_app1_deploy ]

  metadata {
    name = "ingress-nginx"
    namespace = "ingress-nginx"
  }
}

// https://github.com/hashicorp/terraform-provider-kubernetes/issues/353
data "aws_lb" "nginx_nlb" {
  name = "${ substr( data.kubernetes_service.nginx_service_aws_nlb.load_balancer_ingress.0.hostname, 0, 32 ) }"
}

resource "aws_route53_record" "java_app_config" {

  depends_on = [ kubectl_manifest.k8_app1_deploy]

  for_each = var.java_app_r53_domains

  zone_id = var.aws_53_hosted_zone_id
  name    = each.key
  type    = "A"

  alias {
    name                   = data.kubernetes_service.nginx_service_aws_nlb.load_balancer_ingress.0.hostname
    zone_id                = data.aws_lb.nginx_nlb.zone_id
    evaluate_target_health = false
  }
}
