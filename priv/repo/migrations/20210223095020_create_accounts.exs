defmodule Entries.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add(:type, :string, null: false)
      add(:name, :string, null: false)

      timestamps()
    end
  end
end
