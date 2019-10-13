# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :blockchain_graphql, BlockchainGraphqlWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7h5CF4N5qYeqYFiFv+BB0CMYTfGRKJs1AQGIybYBdbl2B1GplfTAncd/pTYa+J4L",
  render_errors: [view: BlockchainGraphqlWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BlockchainGraphql.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# for compiling cuttlefish
System.put_env("NO_ESCRIPT", "1")

config :blockchain,
  seed_nodes:
    Enum.map(
      String.split("/ip4/34.222.64.221/tcp/2154,/ip4/34.208.255.251/tcp/2154", ","),
      &String.to_charlist/1
    ),
  seed_node_dns: String.to_charlist("seed.helium.foundation"),
  base_dir: String.to_charlist("/var/data/blockchain-graphql")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
