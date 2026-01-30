#!/bin/bash
set -e

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

# Start noVNC web interface
cd /usr/share/novnc
git clone https://github.com/novnc/noVNC.git /usr/share/novnc 2>/dev/null || true
/usr/share/novnc/utils/websockify/run $PORT localhost:5900 &

echo "VNC + Orange is ready. Open: http://localhost:$PORT/vnc.html?host=localhost&port=$PORT"
wait
