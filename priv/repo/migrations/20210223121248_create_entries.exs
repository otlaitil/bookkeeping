defmodule Bookkeeping.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add(:debit_id, references(:ledgers), null: false)
      add(:credit_id, references(:ledgers), null: false)
      add(:amount, :integer, null: false)
      add(:date, :naive_datetime, null: false)

      timestamps()
    end

    create(
      constraint("entries", "entry_amount_must_be_positive",
        check: "amount > 0",
        comment: "Entry amount must be positive."
      )
    )
  end
end
