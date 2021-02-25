defmodule Bookkeeping.Account do
  use Ecto.Schema

  @schema_prefix :app
  schema "accounts" do
    field(:type, :string)
    field(:name, :string)

    timestamps()
  end
end
