import Ecto.Query, only: [from: 2]

defmodule Bookkeeping do
  def book(attrs) do
    changeset = Bookkeeping.Entry.new_changeset(attrs)
    Bookkeeping.Repo.insert(changeset)
  end

  def account_balance(%Bookkeeping.Ledger{id: ledger_id} = ledger, date) do
    query =
      from(e in Bookkeeping.Entry,
        where: e.debit_id == ^ledger_id,
        or_where: e.credit_id == ^ledger_id
      )

    entries = Bookkeeping.Repo.all(query)

    entries
    |> Enum.filter(by_date(date))
    |> Enum.reduce(0, balance(ledger))
  end

  defp by_date(date) do
    fn %Entry{date: entry_date} -> entry_date <= date end
  end

  # see credits and debits chart from https://bit.ly/3aILqs9
  defp balance(%Ledger{id: id, type: type}) do
    fn e, acc ->
      case(e) do
        # asset | expense -> credit decreases, debit increases
        %Entry{credit: ^id} when type in ["asset", "expense"] ->
          acc - e.amount

        %Entry{debit: ^id} when type in ["asset", "expense"] ->
          acc + e.amount

        # revenue | liablity -> credit increases, debit decreases
        %Entry{credit: ^id} when type in ["revenue", "liablity"] ->
          acc + e.amount

        %Entry{debit: ^id} when type in ["revenue", "liablity"] ->
          acc - e.amount

        _e ->
          acc
      end
    end
  end
end
