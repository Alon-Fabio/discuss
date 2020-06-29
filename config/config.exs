# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

import_config "prod.secret.exs"

# General application configuration
config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, Discuss.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BIM7HvT/UGLxqXTyHfNvsH1skRj9WKg8jQOQD+8pMeJ3nAXni5A/xKE4IkBHZldY",
  render_errors: [view: Discuss.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"



config :ueberauth, Ueberauth,
  providers: [
    github: { Ueberauth.Strategy.Github, [] }
  ]


# config :ueberauth, Ueberauth.Strategy.Github.OAuth,
#   client_id: {:system, "client_ID"},
#   client_secret: {:system, "secret"}

# config :ueberauth, Ueberauth.Strategy.Github.OAuth,
#   client_id: Application.get_env(:discuss, :oauth)[:github_client_id],
#   client_secret: Application.get_env(:discuss, :oauth)[:github_client_secret]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: System.get_env("GITHUB_CLIENT_ID"),
  client_secret: System.get_env("GITHUB_CLIENT_SECRET")