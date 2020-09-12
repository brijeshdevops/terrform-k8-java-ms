variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "env_type" {
  type        = string
  description = "Type of Environment"
}

variable "aws_53_hosted_zone_id" {
  type = string
  default = "Z3PW93A1VRR17N"
}

variable "java_app_r53_domains" {
  type = set(string)
  description = "List of Java Webapp Domain names"
}