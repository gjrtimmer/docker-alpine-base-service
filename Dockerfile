ARG DOCKER_PROXY
FROM ${DOCKER_PROXY}/linuxserver/baseimage-alpine:3.18

RUN apk add --no-cache --force-overwrite --update \
    curl \
    wget \
    bash \
    coreutils \
    git \
    git-lfs \
    tar \
    gzip \
    bzip2 \
    file \
    shadow \
    findutils \
    openssl \
    ca-certificates && \
    update-ca-certificates

# Compress Image
FROM scratch as runtime
COPY --from=0 / /

ENV PATH=/lsiopy/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    PS1="$(whoami)@$(hostname):$(pwd)\\$ " \
    HOME=/root \
    TERM=xterm \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_VERBOSITY=1 \
    S6_STAGE2_HOOK=/docker-mods \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    VIRTUAL_ENV=/lsiopy

WORKDIR "/"
ENTRYPOINT [ "/init" ]

ARG BUILD_DATE
ARG CI_PROJECT_NAME
ARG CI_PROJECT_URL
ARG VCS_REF

LABEL \
    maintainer="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    build_version="${BUILD_DATE}" \
    org.opencontainers.image.authors="G.J.R. Timmer <gjr.timmer@gmail.com>" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.title="${CI_PROJECT_NAME}" \
    org.opencontainers.image.url="${CI_PROJECT_URL}" \
    org.opencontainers.image.documentation="${CI_PROJECT_URL}" \
    org.opencontainers.image.source="${CI_PROJECT_URL}.git" \
    org.opencontainers.image.ref.name=${VCS_REF} \
    org.opencontainers.image.revision=${VCS_REF} \
    org.opencontainers.image.base.name="ghcr.io/linuxserver/baseimage-alpine:3.18" \
    org.opencontainers.image.licenses=MIT \
    org.opencontainers.image.vendor=timmertech.nl
