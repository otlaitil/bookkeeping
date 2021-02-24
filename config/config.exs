import Config

config :bookkeeping, ecto_repos: [Bookkeeping.Repo]

config :bookkeeping, Bookkeeping.Repo,
  database: "bookkeeping_repo",
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DB_HOST")
