use Mix.Config

config :bookkeeping, ecto_repos: [Bookkeeping.Repo]

import_config "#{Mix.env()}.exs"
