# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :file_uploader,
  ecto_repos: [FileUploader.Repo]

# Configures the endpoint
config :file_uploader, FileUploaderWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "u9wXIBeKFB0zNPWjLAclwVmftA3/dLSKjP2MJr0Y46jk5dldBa0uvM4/4KNLwEzg",
  render_errors: [view: FileUploaderWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: FileUploader.PubSub,
  live_view: [signing_salt: "TGj3CTdt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
