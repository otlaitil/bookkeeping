defmodule Bookkeeping.Entry do
  use Ecto.Schema

  schema "entries" do
    belongs_to(:debit, Bookkeeping.Ledger)
    belongs_to(:credit, Bookkeeping.Ledger)

    field(:amount, :integer)
    field(:date, :naive_datetime)

    timestamps()
  end
end
