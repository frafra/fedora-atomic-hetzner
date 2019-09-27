#!/bin/bash

set -ex -o pipefail

hostnamectl set-hostname "$1"
shift

SYSUSER="hashicorp"

cd "$(dirname ${BASH_SOURCE[0]})"
chmod +x *.sh
./hashicorp-app-setup.sh consul 1.4.0 "${SYSUSER}" "$@"
./hashicorp-app-setup.sh nomad  0.9.5 "${SYSUSER}" "$@"
