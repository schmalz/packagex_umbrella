# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :packagex_web,
  namespace: PackagexWeb

# Configures the endpoint
config :packagex_web, PackagexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wB5x+8ZyoFi8bwSSXeDHw44iYB8mf8XtyRl3lN/n4kLMZmHL3nZaKBD7lcPSSWfA",
  render_errors: [view: PackagexWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PackagexWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :packagex_web, :generators,
  context_app: :packagex

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
