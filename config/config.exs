# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :dbs_tcg,
  ecto_repos: [DbsTcg.Repo]

# Configures the endpoint
config :dbs_tcg, DbsTcg.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hImk4HmnIk1AVpzBGDXNP6ToBt9dUkURZn9JCO/jj27JdwMU86jJmCPSM0ZSlzWO",
  render_errors: [view: DbsTcg.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DbsTcg.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
