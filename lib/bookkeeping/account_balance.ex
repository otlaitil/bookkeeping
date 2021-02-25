defmodule Bookkeeping.AccountBalance do
  use Ecto.Schema

  @primary_key false
  @schema_prefix :app
  schema "account_balances" do
    field(:account_id, :integer)
    field(:balance, :integer)
  end
end
