defmodule Bookkeeping.Ledger do
  use Ecto.Schema

  schema "ledgers" do
    field(:type, :string)
    field(:name, :string)

    timestamps()
  end
end
