# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ex_mon_api,
  ecto_repos: [ExMonApi.Repo]

# Configures the endpoint
config :ex_mon_api, ExMonApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ExMonApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ExMonApi.PubSub,
  live_view: [signing_salt: "jxaIxJa/"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ex_mon_api, ExMonApi.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_mon_api, ExMonApiWeb.Auth.Guardian,
  issuer: "ex_mon_api",
  secret_key: "naCTUOfWVgE9P5ZJrF7giS6GqJeEA05lxzVRixfxRBVpLQf+46v4JW7nZr2R5BHt"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
