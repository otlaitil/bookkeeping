import Config

config :bookkeeping, Bookkeeping.Repo,
  database: "bookkeeping_dev",
  username: "app",
  password: "app",
  hostname: "db"

config :bookkeeping, Bookkeeping.MigrationRepo,
  database: "bookkeeping_dev",
  username: "dba",
  password: "dba",
  hostname: "db",
  after_connect: {Postgrex, :query!, ["SET search_path TO meta", []]}
