defmodule Bookkeeping.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    belongs_to(:debit, Bookkeeping.Ledger)
    belongs_to(:credit, Bookkeeping.Ledger)

    field(:amount, :integer)
    field(:date, :naive_datetime)

    timestamps()
  end

  def new_changeset(attrs) do
    %Bookkeeping.Entry{}
    |> cast(attrs, [:debit_id, :credit_id, :amount, :date])
  end
end
