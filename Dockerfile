FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV HOME=/root
ENV DISPLAY=:0

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
    git \
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

# Install Nerd Font (FiraCode) for terminal
RUN mkdir -p /usr/share/fonts/truetype/nerdfonts && \
    wget -qO /tmp/FiraCode.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip && \
    unzip /tmp/FiraCode.zip -d /usr/share/fonts/truetype/nerdfonts && \
    fc-cache -fv && \
    rm /tmp/FiraCode.zip

# Install Orange (latest stable via pip)
RUN pip3 install --no-cache-dir orange3

# Copy startup script
COPY init.sh /init.sh
RUN chmod +x /init.sh

# Expose Railway port (will be set via env var)
EXPOSE 8080

# Start container
CMD ["/init.sh"]
