#!/bin/bash

set -ex -o pipefail

curl -sSL https://getfedora.org/atomic_raw_x86_64_latest | unxz > /dev/sda
vgscan --mknodes
mkdir root
mount /dev/atomicos/root root
cp -r .ssh root/ostree/deploy/fedora-atomic/var/roothome
umount root

