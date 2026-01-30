#!/usr/bin/env bash
set -e

# Railway ALWAYS injects this
if [[ -z "$PORT" ]]; then
  echo "ERROR: PORT not set by Railway"
  exit 1
fi

# Require password (set in Railway Variables)
if [[ -z "$NOVNC_PASSWORD" ]]; then
  echo "ERROR: NOVNC_PASSWORD not set"
  exit 1
fi

# VNC password
mkdir -p ~/.vnc
echo "$NOVNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Start VNC (local only)
vncserver :0 -geometry 1280x800

# Start noVNC on Railway port
exec /usr/share/novnc/utils/novnc_proxy \
  --listen "$PORT" \
  --vnc localhost:5900 \
  --web /usr/share/novnc
