import Config

config :bookkeeping, ecto_repos: [Entries.Repo, Ledgers.Repo]

config :bookkeeping, Entries.Repo,
  database: "bookkeeping_repo",
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DB_HOST")

config :bookkeeping, Ledgers.Repo,
  database: "bookkeeping_repo",
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DB_HOST")
