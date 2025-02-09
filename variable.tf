variable "ibmcloud_api_key" {
  description = "API Key IBM Cloud"
  type        = string
}

variable "region" {
  description = "IBM Cloud region"
  type        = string
  default     = "us-east"
}

variable "zone" {
  description = "IBM Cloud zone"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name VPC"
  type        = string
  default     = "example-vpc"
}
