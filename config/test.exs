import Config

config :bookkeeping, Bookkeeping.Repo,
  database: "bookkeeping_test",
  username: "app",
  password: "app",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox

config :bookkeeping, Bookkeeping.MigrationRepo,
  database: "bookkeeping_test",
  username: "dba",
  password: "dba",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox,
  after_connect: {Postgrex, :query!, ["SET search_path TO meta", []]}
