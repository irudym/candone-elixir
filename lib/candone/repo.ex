defmodule Candone.Repo do
  use Ecto.Repo,
    otp_app: :candone,
    adapter: Ecto.Adapters.Postgres
end
