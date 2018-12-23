#!/bin/bash

set -ex -o pipefail

set -a
       APP="$1"
   VERSION="$2"
   SYSUSER="$3"
  PLATFORM="linux_amd64"
SERVER_URL="https://releases.hashicorp.com"
    TARGET="/usr/local/bin/${APP}"
      WAIT="3"

shift 3
        IP="$1"
     FIRST="$2"
     NODES="$3"
        DC="$4"
       KEY="$5"
if (( "${NODES}" <= 2 ))
then
  BOOTSTRAP=${NODES}
else
  BOOTSTRAP=$(((1+"${NODES}")/2))
fi
set +a

APP_URL="${SERVER_URL}/${APP}/${VERSION}/${APP}_${VERSION}_${PLATFORM}.zip"
curl -sS "${APP_URL}" | gunzip -S .zip > "${TARGET}"
chmod +x "${TARGET}"

! adduser --system --shell /sbin/nologin "$SYSUSER"

mkdir -p "/etc/${APP}.d/" "/var/lib/${APP}"
chown "${SYSUSER}:${SYSUSER}" "$_"

envsubst < "conf/${APP}.hcl" > "/etc/${APP}.d/${APP}.hcl"
envsubst < "services/${APP}.service" > "/etc/systemd/system/${APP}.service"

systemctl enable "$APP"
systemctl start "$_"

sleep "${WAIT}"
systemctl is-active --quiet "$APP"
