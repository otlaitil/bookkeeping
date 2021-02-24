defmodule Mix.Tasks.Roles do
  use Mix.Task

  @shortdoc "Creates database roles."
  def run(_) do
    Application.ensure_all_started(:postgrex)

    {:ok, pid} =
      Postgrex.start_link(
        hostname: "db",
        username: "postgres",
        password: "postgres",
        database: "postgres"
      )

    create_dba_user_sql = "CREATE USER dba WITH LOGIN CREATEDB PASSWORD 'dba';"
    create_app_user_sql = "CREATE USER app WITH LOGIN PASSWORD 'app';"

    Postgrex.query!(pid, create_dba_user_sql, [])
    Postgrex.query!(pid, create_app_user_sql, [])
  end
end
