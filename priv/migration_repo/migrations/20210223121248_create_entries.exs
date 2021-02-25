defmodule Bookkeeping.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries, prefix: :app) do
      add(:debit_id, references(:accounts), null: false, on_delete: :restrict)
      add(:credit_id, references(:accounts), null: false, on_delete: :restrict)
      add(:amount, :integer, null: false)
      add(:date, :naive_datetime, null: false)

      timestamps()
    end

    create(index(:entries, [:debit_id], prefix: :app))
    create(index(:entries, [:credit_id], prefix: :app))

    create(
      constraint(:entries, "entry_amount_must_be_positive",
        check: "amount > 0",
        comment: "Entry amount must be positive.",
        prefix: :app
      )
    )

    execute(
      """
      GRANT SELECT, INSERT
      ON app.entries
      TO app;
      """,
      ""
    )

    execute(
      """
      GRANT USAGE
      ON SEQUENCE app.entries_id_seq
      TO app;
      """,
      ""
    )
  end
end
