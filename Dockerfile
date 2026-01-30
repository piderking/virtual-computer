ARG MINIFORGE_VERSION=24.11.3-0
FROM condaforge/miniforge3:${MINIFORGE_VERSION}

ARG TIGERVNC_VERSION=1.10.1+dfsg-3ubuntu0.20.04.1
ARG FLUXBOX_VERSION=1.3.5-2build2
ARG UNZIP_VERSION=6.0-25ubuntu1.1
ARG NOVNC_VERSION=1.5.0
ARG ORANGE3_VERSION=3.38.1
ARG PYTHON_VERSION=3.10

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# System deps
RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server=${TIGERVNC_VERSION} \
    fluxbox=${FLUXBOX_VERSION} \
    unzip=${UNZIP_VERSION} \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# noVNC
RUN wget -q https://github.com/novnc/noVNC/archive/refs/tags/v${NOVNC_VERSION}.zip && \
    unzip v${NOVNC_VERSION}.zip -d /usr/share && \
    mv /usr/share/noVNC-${NOVNC_VERSION} /usr/share/novnc && \
    rm v${NOVNC_VERSION}.zip && \
    apt-get purge -y unzip && apt-get autoremove -y

ENV PATH=/usr/share/novnc/utils:/opt/conda/envs/orange3/bin:$PATH

# Conda env (no conda init)
RUN conda create -n orange3 python=${PYTHON_VERSION} \
    orange3=${ORANGE3_VERSION} "catboost=*=*cpu*" -y && \
    conda clean -afy

# Runtime env
ENV DISPLAY=:0 \
    SHARED=0 \
    PORT=6080

EXPOSE 6080

# Optional data
COPY ./dat[a]/ /data/

# Entrypoint
COPY --chmod=700 init.sh /app/init.sh
ENTRYPOINT ["/app/init.sh"]
