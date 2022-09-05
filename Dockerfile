FROM elixir:1.13.4

ENV NODE_VERSION=16.2.0 \
    LANG=C.UTF-8 \
    NPM_CONFIG_LOGLEVEL=info

RUN mix local.hex --force && mix local.rebar --force

RUN apt-get update \
    && apt-get install -y \
    curl \
    make \
    build-essential \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_16.x \
    | bash - && sudo apt-get install -y nodejs

RUN npm install -g yarn@^1.22.5

RUN apt-get install -y inotify-tools

RUN mkdir -p /app
WORKDIR /app
