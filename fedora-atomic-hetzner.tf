# Set the variable value in terraform.tfvars file
# or using -var="hcloud_token=..." CLI option
variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}

# Create a new SSH key
resource "hcloud_ssh_key" "default" {
  name       = "terraform"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# Encryption key (base64)
resource "random_string" "encryption_key" {
  length           = 32
  override_special = "+/"
}

# Create a server
resource "hcloud_server" "atomic" {
  count       = 2
  name        = "fedora-atomic-${count.index}"
  image       = "fedora-30"  # not relevant
  server_type = "cx11"
  rescue      = "linux64"
  ssh_keys    = ["${hcloud_ssh_key.default.id}"]
  provisioner "file" {
    source      = "scripts/fedora-atomic.sh"
    destination = "/tmp/fedora-atomic.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "bash /tmp/fedora-atomic.sh"
    ]
  }
  provisioner "file" {
    source      = "scripts"
    destination = "/tmp/scripts"
  }
  provisioner "remote-exec" {
    inline = [
      <<EOF
        bash /tmp/scripts/setup.sh \
            ${self.name} \
            ${self.ipv4_address} \
            ${hcloud_server.atomic.0.ipv4_address} \
            ${self.count} \
            ${self.datacenter} \
            ${random_string.encryption_key.result} \
        EOF
    ]
  }
}

output "ipv4" {
  value = "${hcloud_server.atomic.*.ipv4_address}"
}

output "ipv6" {
  value = "${hcloud_server.atomic.*.ipv6_address}"
}

output "user" {
  value = "root"
}

