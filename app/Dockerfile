#
# Development
#

FROM elixir:1.12 as development

ENV APP_HOME=/usr/src/app \
  HEX_HTTP_TIMEOUT=30 \
  LANG=C.UTF-8 \
  REFRESHED_AT=2020-12-01

WORKDIR $APP_HOME

# install supporting tools
RUN mix local.hex --force
RUN mix local.rebar --force

# copy dependencies
COPY ./config config
COPY ./mix.exs ./mix.lock ./.formatter.exs ./

RUN MIX_ENV=prod mix do deps.get deps.compile

# copy in the applications
COPY ./ ./

RUN mix phx.digest

# create a release
RUN MIX_ENV=prod mix release production

#
# Deploy
#
FROM debian:buster-slim as deploy

ENV APP_HOME /usr/src/app
ENV LANG C.UTF-8

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
