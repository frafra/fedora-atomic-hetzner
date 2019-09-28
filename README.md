# Fedora Atomic on Hetzner

Deploy the latest [Fedora Atomic](http://www.projectatomic.io/) image on a [Hetzner](https://www.hetzner.com/) VPS using [Terraform](https://www.terraform.io/) and install and configure [Nomad](https://www.nomadproject.io/) and [Consul](https://www.consul.io/).

## Requirements

 1. An account on [Hetzner](https://www.hetzner.com/)
 2. An SSH key
 3. [Terraform](https://www.terraform.io/downloads.html) installed, v0.11 (not compatible with v0.12)

## Setup

 1. Generate an API key on [Hetzner cloud](https://console.hetzner.cloud/)
 2. Write `hcloud_token = "YOUR_API_KEY"` in a file named `terraform.tfvars` (*optional*)
 3. `$ terraform init`

## Run

 1. `$ terraform apply`

Use the output to connect to the server using SSH.

## Known issues

 - If you already have uploaded an SSH to Hetzner Cloud, you should remove it or import it into Terraform.
 - [Can no longer reboot and continue. · Issue #17844 · hashicorp/terraform](https://github.com/hashicorp/terraform/issues/17844)

