defmodule Bookkeeping.AccountLedger do
  use Ecto.Schema

  @primary_key false
  schema "account_ledgers" do
    field(:account_id, :integer)
    field(:entry_id, :integer)
    field(:amount, :integer)
  end
end
