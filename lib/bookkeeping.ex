import Ecto.Query

alias Bookkeeping.Account
alias Bookkeeping.Entry
alias Bookkeeping.Repo

defmodule Bookkeeping do
  def book(attrs) do
    changeset = Entry.new_changeset(attrs)
    Repo.insert(changeset)
  end

  def account_balance(%Account{id: account_id} = account, date) do
    entries =
      Entry
      |> where(debit_id: ^account_id)
      |> or_where(credit_id: ^account_id)
      |> where([e], e.date <= ^date)
      |> Repo.all()

    entries
    |> Enum.reduce(0, balance(account))
  end

  # see credits and debits chart from https://bit.ly/3aILqs9
  defp balance(%Account{id: account_id, type: account_type}) do
    fn e, acc ->
      case(e) do
        # asset | expense -> credit decreases, debit increases
        %Entry{credit_id: ^account_id} when account_type in ["asset", "expense"] ->
          acc - e.amount

        %Entry{debit_id: ^account_id} when account_type in ["asset", "expense"] ->
          acc + e.amount

        # revenue | equity | liablity -> credit increases, debit decreases
        %Entry{credit_id: ^account_id} when account_type in ["revenue", "equity", "liablity"] ->
          acc + e.amount

        %Entry{debit_id: ^account_id} when account_type in ["revenue", "equity", "liablity"] ->
          acc - e.amount

        _e ->
          acc
      end
    end
  end
end
