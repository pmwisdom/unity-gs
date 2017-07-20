# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :unity_gs,
  ecto_repos: [UnityGs.Repo]

# Configures the endpoint
config :unity_gs, UnityGs.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mVY2zZZX5UV2uWW5Axb4zRJKRAXE0TSkBRMrU521/AIWKsq5/9buZAQiB08LZYjz",
  render_errors: [view: UnityGs.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UnityGs.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
