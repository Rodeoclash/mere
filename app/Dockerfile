#
# Development
#

FROM elixir:1.12 as development

ENV APP_HOME=/usr/src/app \
  HEX_HTTP_TIMEOUT=30 \
  LANG=C.UTF-8 \
  MIX_ENV=prod

WORKDIR $APP_HOME

# install supporting tools
RUN mix local.hex --force
RUN mix local.rebar --force

# copy dependencies
COPY ./config config
COPY ./mix.exs ./mix.lock ./.formatter.exs ./

RUN mix do deps.get deps.compile

# copy in the applications
COPY ./assets ./assets
COPY ./lib ./lib
COPY ./priv ./priv

RUN mix assets.deploy

# create a release
RUN mix release production

#
# Deploy
#
FROM debian:buster-slim as deploy

ENV APP_HOME=/usr/src/app \
    MIX_ENV=prod \
    LANG=C.UTF-8

EXPOSE 4000

WORKDIR $APP_HOME

# Install libs
RUN apt-get update && \
    apt-get install -yq \
    libssl-dev \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY --from=development $APP_HOME/_build/prod/rel/production $APP_HOME

CMD bin/production start
