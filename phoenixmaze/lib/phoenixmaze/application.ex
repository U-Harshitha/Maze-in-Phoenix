defmodule Phoenixmaze.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true

  def start(_type, _args) do
    children = [
      PhoenixmazeWeb.Telemetry,
      Phoenixmaze.Repo,
      {DNSCluster, query: Application.get_env(:phoenixmaze, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Phoenixmaze.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Phoenixmaze.Finch},
      # Start a worker by calling: Phoenixmaze.Worker.start_link(arg)
      # {Phoenixmaze.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixmazeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Phoenixmaze.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixmazeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
