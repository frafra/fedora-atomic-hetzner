bind_addr  = "${IP}"
datacenter = "${DC}"
data_dir   = "/var/lib/nomad"

consul {
  server_service_name = "${HOSTNAME}-nomad-server"
  client_service_name = "${HOSTNAME}-nomad-client"
}

server {
  enabled          = true
  bootstrap_expect = "${BOOTSTRAP}"
}

client {
  enabled = true
}
