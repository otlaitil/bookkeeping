defmodule Bookkeeping.Factory do
  alias Bookkeeping.Repo
  alias Bookkeeping.Account
  alias Bookkeeping.Entry

  def build(:account) do
    %Account{name: "Bank Account", type: "asset"}
  end

  def build(:entry) do
    %Entry{date: ~U[2021-01-01 00:00:00Z], amount: 1000_00}
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
