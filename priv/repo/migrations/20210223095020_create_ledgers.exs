defmodule Entries.Repo.Migrations.CreateLedgers do
  use Ecto.Migration

  def change do
    create table(:ledgers) do
      add(:type, :string, null: false)
      add(:name, :string, null: false)

      timestamps()
    end
  end
end
