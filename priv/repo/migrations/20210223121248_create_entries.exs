defmodule Bookkeeping.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add(:debit, references(:ledgers), null: false)
      add(:credit, references(:ledgers), null: false)
      add(:amount, :integer, null: false)
      add(:date, :naive_datetime, null: false)

      timestamps()
    end
  end
end
