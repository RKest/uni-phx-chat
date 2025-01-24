defmodule UniElixir.Repo do
  use Ecto.Repo,
    otp_app: :uni_elixir,
    adapter: Ecto.Adapters.Postgres
end
