# Set the variable value in terraform.tfvars file
# or using -var="hcloud_token=..." CLI option
variable "hcloud_token" {}

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = "${var.hcloud_token}"
}

# Create a new SSH key
resource "hcloud_ssh_key" "default" {
  name = "terraform"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# Create a server
resource "hcloud_server" "atomic" {
  name = "fedora-atomic"
  image = "fedora-28"  # not relevant
  server_type = "cx11"
  rescue = "linux64"
  ssh_keys = ["${hcloud_ssh_key.default.id}"]
  labels = {
    os = "fedora-atomic",
  }
  provisioner "file" {
    source = "fedora-atomic.sh"
    destination = "/tmp/fedora-atomic.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/fedora-atomic.sh",
      "/tmp/fedora-atomic.sh",
      "shutdown -r +0",
    ]
  }
}

output "ipv4" {
  value = "${hcloud_server.atomic.ipv4_address}"
}

output "ipv6" {
  value = "${hcloud_server.atomic.ipv6_address}"
}

output "user" {
  value = "root"
}

