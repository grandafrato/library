# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :console,
  generators: [context_app: false]

# Configures the endpoint
config :console, Console.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Slpw63KnZQS17SYqVCObnqdM9jqAo3TdFqCQ0JxYBuDO/0W9itYy/u6w3jtjRydx",
  render_errors: [view: Console.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Console.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "y2qI5tMi"]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :library_firmware, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1585023006"

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]

if Mix.target() != :host do
  config :console, Console.Endpoint,
    code_reloader: false,
    http: [port: 80],
    load_from_system_env: false,
    server: true,
    url: [host: "nerves.local", port: 80]
    
  import_config "target.exs"
end
