import Config

# Configure your database
config :phoenixmaze, Phoenixmaze.Repo,
  username: "postgres",
  password: "25feb@005",
  hostname: "localhost",
  database: "phoenixmaze_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
config :phoenixmaze, PhoenixmazeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "Gx+6LZMmXH8zPRgL3x9AIR0c4jmqFtHvHBeWodBzovtAc8Lvfnm+vpzhsEvqBs5e",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:phoenixmaze, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:phoenixmaze, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :phoenixmaze, PhoenixmazeWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg|mp4)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/phoenixmaze_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :phoenixmaze, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Configure LiveView
config :phoenix_live_view,
  debug_heex_annotations: true,
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
