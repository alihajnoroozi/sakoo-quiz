# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mafia,
  ecto_repos: [Mafia.Repo],
  product_name: System.get_env("product_name")

# Configures the endpoint
config :mafia, MafiaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "53Ep0mB4MjtdcmKLAnSmk6qaOI6XYr550FqPqbW47YiAlySUw2tLcz2BxgafeTkr",
  render_errors: [view: MafiaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mafia.PubSub,
  live_view: [signing_salt: "6ts+qOwe"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :joken, default_signer: System.fetch_env!("JWT_SIGN_KEY")

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
