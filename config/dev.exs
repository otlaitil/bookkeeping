import Config

config :bookkeeping, Bookkeeping.Repo,
  database: "bookkeeping_dev",
  username: "postgres",
  password: "postgres",
  hostname: "db"
