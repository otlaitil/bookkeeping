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
    restrict_meta_schema = "REVOKE ALL PRIVILEGES ON SCHEMA meta FROM PUBLIC;"
    add_app_schema = "CREATE SCHEMA app AUTHORIZATION dba;"

    grant_app_schema_usage = "GRANT USAGE ON SCHEMA app TO app;"

    Postgrex.query!(pid, drop_public_schema, [])
    Postgrex.query!(pid, add_meta_schema, [])
    Postgrex.query!(pid, restrict_meta_schema, [])
    Postgrex.query!(pid, add_app_schema, [])
    Postgrex.query!(pid, grant_app_schema_usage, [])
  end
end
