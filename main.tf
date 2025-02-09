terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.51.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

resource "ibm_is_vpc" "example_vpc" {
  name = var.vpc_name
}

resource "ibm_is_subnet" "example_subnet" {
  name   = "example-subnet"
  vpc_id = ibm_is_vpc.example_vpc.id
  zone   = var.zone
  cidr   = "10.0.0.0/24"
}

resource "ibm_is_key" "ssh_key" {
  name       = "example-ssh-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "ibm_is_security_group" "example_sg" {
  name        = "example-security-group"
  vpc_id      = ibm_is_vpc.example_vpc.id
  description = "Security group for example instance"

  ingress {
    protocol   = "tcp"
    port_range = "22"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol   = "tcp"
    port_range = "80"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "ibm_is_instance" "example_instance" {
  name              = "ExampleInstance"
  image_id          = "r006-47f4ecb5-161e-4732-8f09-d05fcb8b50f4" 
  profile           = "bx2-2x8" 
  zone              = var.zone
  vpc_id            = ibm_is_vpc.example_vpc.id
  subnet_id         = ibm_is_subnet.example_subnet.id
  keys              = [ibm_is_key.ssh_key.id]
  security_group_ids = [ibm_is_security_group.example_sg.id]
  tags              = ["ExampleAppServerInstance"]
}

output "instance_id" {
  description = "ID of the created instance"
  value       = ibm_is_instance.example_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = ibm_is_instance.example_instance.primary_network_interface.0.primary_ipv4_address
}
