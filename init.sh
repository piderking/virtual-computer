#!/bin/bash
set -e

# Use Railway environment variables or defaults
VNC_PASSWORD=${VNC_PASSWORD:-railway}
PORT=${PORT:-8080}

# Setup VNC password
mkdir -p $HOME/.vnc
echo $VNC_PASSWORD | vncpasswd -f > $HOME/.vnc/passwd
chmod 600 $HOME/.vnc/passwd

# Kill previous VNC sessions
vncserver -kill :0 2>/dev/null || true

# Start VNC server
vncserver :0 -geometry 1920x1080 -depth 24

# Start Fluxbox window manager
fluxbox &

# Clipboard sync: VNC clipboard -> system clipboard
while true; do
    sleep 1
    xclip -selection clipboard -o 2>/dev/null | xclip -selection primary -i 2>/dev/null
done &

# Persist Orange data to volume
mkdir -p /data/orange-data
mkdir -p ~/.local/share
ln -sf /data/orange-data ~/.local/share/Orange 2>/dev/null || true

# Start Orange automatically
python3 -m Orange.canvas &

# Setup terminal shortcut on desktop
mkdir -p ~/Desktop
cat > ~/Desktop/Terminal.desktop <<'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal
Comment=Terminal Emulator
Exec=xterm -fa 'FiraCode Nerd Font' -fs 14
Icon=utilities-terminal
Terminal=false
Categories=System;
EOF
chmod +x ~/Desktop/Terminal.desktop

# Install noVNC to persistent volume if not present
if [ ! -d /data/novnc ]; then
    echo "Installing noVNC to persistent volume..."
    git clone https://github.com/novnc/noVNC.git /data/novnc
fi

# Start noVNC web interface from persistent volume
/data/novnc/utils/websockify/run $PORT localhost:5900 &

echo "=========================================="
echo "VNC + Orange is ready!"
echo "PORT: $PORT"
echo "Access via your Railway public URL"
echo "=========================================="

wait
