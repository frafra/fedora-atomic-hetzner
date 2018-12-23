server           = true
bind_addr        = "${IP}"
retry_join       = ["$FIRST"]
bootstrap_expect = ${BOOTSTRAP}
datacenter       = "${DC}"
data_dir         = "/var/lib/consul"
encrypt          = "${KEY}"
