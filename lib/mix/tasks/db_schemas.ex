defmodule Mix.Tasks.DbSchemas do
  use Mix.Task

  @shortdoc "Creates db schemas."
  def run(_) do
    Application.ensure_all_started(:postgrex)

    {:ok, pid} =
      Postgrex.start_link(
        hostname: "db",
        username: "postgres",
        password: "postgres",
        database: "bookkeeping_#{Mix.env()}"
      )

    drop_public_schema = "DROP SCHEMA public;"
    add_meta_schema = "CREATE SCHEMA meta AUTHORIZATION dba;"

    Postgrex.query!(pid, drop_public_schema, [])
    Postgrex.query!(pid, add_meta_schema, [])
  end
end
