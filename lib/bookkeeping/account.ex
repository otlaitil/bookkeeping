defmodule Bookkeeping.Account do
  use Ecto.Schema

  schema "accounts" do
    field(:type, :string)
    field(:name, :string)

    timestamps()
  end
end
