defmodule Entries.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, prefix: :app) do
      add(:type, :string, null: false)
      add(:name, :string, null: false)

      timestamps()
    end

    execute(
      """
      GRANT SELECT, INSERT, UPDATE, DELETE
      ON TABLE app.accounts
      TO app;
      """,
      ""
    )

    execute(
      """
      GRANT USAGE
      ON SEQUENCE app.accounts_id_seq
      TO app;
      """,
      ""
    )
  end
end
