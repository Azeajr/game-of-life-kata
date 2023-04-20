defmodule GOL.Repo do
  use Ecto.Repo,
    otp_app: :gol_phoenix,
    adapter: Ecto.Adapters.Postgres
end
