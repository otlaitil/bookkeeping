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
  end
end
