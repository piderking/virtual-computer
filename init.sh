#!/usr/bin/env bash
set -e

# Use Railway-assigned port
NOVNC_PORT="${PORT:-6080}"

# VNC password (runtime secret)
mkdir -p ~/.vnc
if [[ -n "$NOVNC_PASSWORD" ]]; then
  echo "$NOVNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
  chmod 600 ~/.vnc/passwd
else
  echo "⚠️  NOVNC_PASSWORD not set – VNC is unsecured"
fi

# Start X / window manager
vncserver :0 -localhost no -geometry 1280x800 -SecurityTypes None
fluxbox &

# noVNC
/usr/share/novnc/utils/novnc_proxy \
  --vnc localhost:5900 \
  --listen "$NOVNC_PORT"
