import Ecto.Query

alias Bookkeeping.Ledger, as: Ledger
alias Bookkeeping.Entry, as: Entry
alias Bookkeeping.Repo, as: Repo

defmodule Bookkeeping do
  def book(attrs) do
    changeset = Entry.new_changeset(attrs)
    Repo.insert(changeset)
  end

  def account_balance(%Ledger{id: ledger_id} = ledger, date) do
    entries =
      Entry
      |> where(debit_id: ^ledger_id)
      |> or_where(credit_id: ^ledger_id)
      |> Repo.all()

    entries
    |> Enum.filter(by_date(date))
    |> Enum.reduce(0, balance(ledger))
  end

  defp by_date(date) do
    fn %Entry{date: entry_date} -> entry_date <= date end
  end

  # see credits and debits chart from https://bit.ly/3aILqs9
  defp balance(%Ledger{id: ledger_id, type: ledger_type}) do
    fn e, acc ->
      case(e) do
        # asset | expense -> credit decreases, debit increases
        %Entry{credit_id: ^ledger_id} when ledger_type in ["asset", "expense"] ->
          acc - e.amount

        %Entry{debit_id: ^ledger_id} when ledger_type in ["asset", "expense"] ->
          acc + e.amount

        # revenue | liablity -> credit increases, debit decreases
        %Entry{credit_id: ^ledger_id} when ledger_type in ["revenue", "liablity"] ->
          acc + e.amount

        %Entry{debit_id: ^ledger_id} when ledger_type in ["revenue", "liablity"] ->
          acc - e.amount

        _e ->
          acc
      end
    end
  end
end
