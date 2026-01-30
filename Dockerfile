FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV HOME=/root
ENV DISPLAY=:0
ENV VNC_PASSWORD=railway
ENV PORT=8080

# Install essentials, VNC, Fluxbox, fonts, clipboard, Orange dependencies
RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server \
    fluxbox \
    fbpanel \
    xterm \
    x11-xserver-utils \
    xclip \
    wget \
    unzip \
    ca-certificates \
    fontconfig \
    locales \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# VNC password
RUN mkdir -p $HOME/.vnc && \
    echo $VNC_PASSWORD | vncpasswd -f > $HOME/.vnc/passwd && \
    chmod 600 $HOME/.vnc/passwd

# Install Nerd Font (FiraCode) for terminal
RUN mkdir -p /usr/share/fonts/truetype/nerdfonts && \
    wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip \
    | bsdtar -xvf- -C /usr/share/fonts/truetype/nerdfonts && \
    fc-cache -fv

# Install Orange (latest stable via pip)
RUN pip3 install --no-cache-dir orange3

# Copy startup script
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Mount volume
VOLUME ["/data"]

# Expose Railway port
EXPOSE $PORT

# Start container
CMD ["/init.sh"]
