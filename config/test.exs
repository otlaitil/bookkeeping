import Config

config :bookkeeping, Bookkeeping.Repo,
  database: "bookkeeping_test",
  username: "postgres",
  password: "postgres",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox
