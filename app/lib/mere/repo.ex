defmodule Mere.Repo do
  use Ecto.Repo,
    otp_app: :mere,
    adapter: Ecto.Adapters.Postgres
end
