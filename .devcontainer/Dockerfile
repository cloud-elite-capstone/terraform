FROM node:lts-trixie-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    gnupg \
    graphviz \
    jq \
    sudo \
    unzip \
    tree \
    zsh \
    && rm -rf /var/lib/apt/lists/*
