#!/usr/bin/env bash
set -e

NOVNC_PORT="${PORT:-6080}"

# Create VNC password (required)
mkdir -p ~/.vnc

if [[ -z "$NOVNC_PASSWORD" ]]; then
  echo "ERROR: NOVNC_PASSWORD is required"
  exit 1
fi

echo "$NOVNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Start VNC server (LOCAL ONLY — this is critical)
vncserver :0 -geometry 1280x800

# Start window manager
fluxbox &

# Expose desktop via noVNC (public)
exec /usr/share/novnc/utils/novnc_proxy \
  --vnc localhost:5900 \
  --listen "$NOVNC_PORT"
