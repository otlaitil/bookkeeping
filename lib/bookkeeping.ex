import Ecto.Query

alias Bookkeeping.Account
alias Bookkeeping.AccountBalance
alias Bookkeeping.Entry
alias Bookkeeping.Repo

defmodule Bookkeeping do
  def book(attrs) do
    changeset = Entry.new_changeset(attrs)
    Repo.insert(changeset)
  end

  def account_balance(%Account{id: account_id} = account) do
    AccountBalance
    |> where(account_id: ^account_id)
    |> select([a], a.balance)
    |> Repo.one()
  end
end
