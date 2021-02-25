use Mix.Config

config :bookkeeping, ecto_repos: [Bookkeeping.Repo, Bookkeeping.MigrationRepo]

import_config "#{Mix.env()}.exs"
