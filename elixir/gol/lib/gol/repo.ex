defmodule Gol.Repo do
  use Ecto.Repo,
    otp_app: :gol,
    adapter: Ecto.Adapters.Postgres
end
