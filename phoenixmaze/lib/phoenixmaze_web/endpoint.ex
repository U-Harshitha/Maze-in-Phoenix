defmodule PhoenixmazeWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :phoenixmaze

  # Add this before the LiveView socket
  plug Plug.Static,
    at: "/",
    from: :phoenixmaze,
    gzip: false,
    only: ~w(assets fonts images videos favicon.ico robots.txt)
    @session_options [
      store: :cookie,
      key: "_phoenixmaze_key",
      signing_salt: "6lGTtFZZ",
      same_site: "Lax"
    ]

    socket "/live", Phoenix.LiveView.Socket,
      websocket: [connect_info: [session: @session_options]],
      longpoll: [connect_info: [session: @session_options]]

    # Serve at "/" the static files from "priv/static" directory.
    #
    # You should set gzip to true if you are running phx.digest
    # when deploying your static files in production.
    plug Plug.Static,
      at: "/",
      from: :phoenixmaze,
      gzip: false,
      only: ~w(assets fonts images favicon.ico robots.txt amazedinto.mp4)

    # Code reloading can be explicitly enabled under the
    # :code_reloader configuration of your endpoint.
    if code_reloading? do
      socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
      plug Phoenix.LiveReloader
      plug Phoenix.CodeReloader
      plug Phoenix.Ecto.CheckRepoStatus, otp_app: :phoenixmaze
    end

    plug Phoenix.LiveDashboard.RequestLogger,
      param_key: "request_logger",
      cookie_key: "request_logger"

    plug Plug.RequestId
    plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json],
      pass: ["*/*"],
      json_decoder: Phoenix.json_library()

    plug Plug.MethodOverride
    plug Plug.Head
    plug Plug.Session, @session_options
    plug PhoenixmazeWeb.Router
  # The rest of your endpoint.ex file...
end
