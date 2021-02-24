defmodule Bookkeeping.MixProject do
  use Mix.Project

  def project do
    [
      app: :bookkeeping,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bookkeeping.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.5"},
      {:postgrex, ">= 0.0.0"}
    ]
  end

  defp aliases do
    [
      setup: ["roles", "ecto.create", "db_schemas"],
      test: ["ecto.drop --quiet", "ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
