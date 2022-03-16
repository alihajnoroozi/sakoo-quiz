defmodule Mafia.Repo do
  use Ecto.Repo,
    otp_app: :mafia,
    adapter: Ecto.Adapters.Postgres
end
