defmodule Bookkeeping.AccountBalance do
  use Ecto.Schema

  @primary_key false
  schema "account_balances" do
    field(:account_id, :integer)
    field(:balance, :integer)
  end
end
