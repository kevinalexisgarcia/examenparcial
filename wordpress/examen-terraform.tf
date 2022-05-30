#Provider
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.20.0"
    }
  }
}

#Variables declaradas en el archivo terraform.tfvars
variable "do_token" {}
variable "ssh_key_private_site1" {}
variable "droplet_ssh_key_id_site1" {}
variable "droplet_name_site1" {}
variable "droplet_size_site1" {}
variable "droplet_region_site1" {}

variable "ssh_key_private_site2" {}
variable "droplet_ssh_key_id_site2" {}
variable "droplet_name_site2" {}
variable "droplet_size_site2" {}
variable "droplet_region_site2" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
    token = "${var.do_token}"
}

#Creación de la VPC
resource "digitalocean_vpc" "red-privada" {
  name   = "red-privada"
  region = "nyc1"
  ip_range = "172.16.200.0/24"
}

# Create a web server 1
resource "digitalocean_droplet" "site1" {
    image  = "centos-7-x64"
    name   = "${var.droplet_name_site1}"
    region = "${var.droplet_region_site1}"
    size   = "${var.droplet_size_site1}"
    monitoring = "true"
    ssh_keys = ["${var.droplet_ssh_key_id_site1}"]
    vpc_uuid = digitalocean_vpc.red-privada.id

    # Install python on the droplet using remote-exec to execute ansible playbooks to configure the services
    provisioner "remote-exec" {
        inline = [
          "yum install python -y",
        ]

         connection {
            host        = "${self.ipv4_address}"
            type        = "ssh"
            user        = "root"
            private_key = "${file("${var.ssh_key_private_site1}")}"
        }
    }

    # Execute ansible playbooks using local-exec 
    provisioner "local-exec" {
        environment = {
            PUBLIC_IP                 = "${self.ipv4_address}"
            PRIVATE_IP                = "${self.ipv4_address_private}"
            ANSIBLE_HOST_KEY_CHECKING = "False" 
        }

        working_dir = "playbooks/"
        command     = "ansible-playbook -u root --private-key ${var.ssh_key_private_site1} -i ${self.ipv4_address}, wordpress_playbook.yml"
    }
}


# Create a web server 2
resource "digitalocean_droplet" "site2" {
    image  = "centos-7-x64"
    name   = "${var.droplet_name_site2}"
    region = "${var.droplet_region_site2}"
    size   = "${var.droplet_size_site2}"
    monitoring = "true"
    ssh_keys = ["${var.droplet_ssh_key_id_site2}"]
    vpc_uuid = digitalocean_vpc.red-privada.id

    # Install python on the droplet using remote-exec to execute ansible playbooks to configure the services
    provisioner "remote-exec" {
        inline = [
          "yum install python -y",
        ]

         connection {
            host        = "${self.ipv4_address}"
            type        = "ssh"
            user        = "root"
            private_key = "${file("${var.ssh_key_private_site2}")}"
        }
    }

    # Execute ansible playbooks using local-exec 
    provisioner "local-exec" {
        environment = {
            PUBLIC_IP                 = "${self.ipv4_address}"
            PRIVATE_IP                = "${self.ipv4_address_private}"
            ANSIBLE_HOST_KEY_CHECKING = "False" 
        }

        working_dir = "playbooks/"
        command     = "ansible-playbook -u root --private-key ${var.ssh_key_private_site2} -i ${self.ipv4_address}, wordpress_playbook.yml"
    }
}

#Creacion de loadbalance para Wordpress

resource "digitalocean_loadbalancer" "resource-balancer" {
  name = "resource-balancer"
  region = "nyc1"
  vpc_uuid = digitalocean_vpc.red-privada.id
  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"
    target_port = 80
    target_protocol = "http"
  }
  healthcheck {
    port = 80
    protocol = "tcp"
  }
  droplet_ids = [digitalocean_droplet.site1.id, digitalocean_droplet.site2.id ]
}