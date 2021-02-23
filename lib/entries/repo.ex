defmodule Entries.Repo do
  use Ecto.Repo,
    otp_app: :bookkeeping,
    adapter: Ecto.Adapters.Postgres
end
