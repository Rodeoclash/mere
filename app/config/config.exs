# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :mere,
  public_name: "Mere",
  ecto_repos: [Mere.Repo]

# Configures the endpoint
config :mere, MereWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: MereWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mere.PubSub,
  live_view: [signing_salt: "cvUBcfFl"]

config :mere, :pow,
  user: Mere.Users.User,
  repo: Mere.Repo,
  routes_backend: MereWeb.Pow.Routes

config :ex_cldr,
  default_locale: "en",
  default_backend: Mere.Cldr

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :mere, Mere.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js js/user.js --loader:.jpg=file --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mere, Oban,
  repo: Mere.Repo,
  queues: [
    cron: 1,
    update_youtube_channel: 2,
    update_youtube_playlist_item: 2
  ],
  plugins: [
    {Oban.Plugins.Cron,
     crontab: [
       {"* * * * *", Mere.Cron.RefreshUserIdentities}
     ]}
  ]

config :sentry,
  dsn: "https://1098d697325c4b62a382f904d47374e6@o1029363.ingest.sentry.io/5996367",
  environment_name: Mix.env(),
  included_environments: [:prod]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
