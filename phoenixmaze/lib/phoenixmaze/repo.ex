defmodule Phoenixmaze.Repo do
  use Ecto.Repo,
    otp_app: :phoenixmaze,
    adapter: Ecto.Adapters.Postgres
end
