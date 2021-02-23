defmodule Bookkeeping do
  @spec start :: boolean()
  def start do
    unless Enum.member?(:ets.all(), :bookkeeping) do
      :ets.new(:bookkeeping, [:public, :named_table])
      :ets.insert(:bookkeeping, {:entries, []})
    end
  end

  @spec book(Entry.t()) :: Entry.t()
  def book(%Entry{} = entry) do
    [{_key, entries}] = :ets.lookup(:bookkeeping, :entries)
    :ets.insert(:bookkeeping, {:entries, [entry | entries]})

    entry
  end

  @spec account_balance(Ledger.t(), Date.t()) :: integer()
  def account_balance(%Ledger{} = ledger, date) do
    [{_key, entries}] = :ets.lookup(:bookkeeping, :entries)

    entries
    |> Enum.filter(by_date(date))
    |> Enum.reduce(0, balance(ledger))
  end

  defp by_date(date) do
    fn %Entry{date: entry_date} -> entry_date <= date end
  end

  # see credits and debits chart from https://bit.ly/3aILqs9
  defp balance(%Ledger{id: id, type: type}) do
    fn (e, acc) ->
      case(e) do
        # asset | expense -> credit decreases, debit increases
        %Entry{credit: ^id} when type in [:asset, :expense] ->
          acc - e.amount

        %Entry{debit: ^id} when type in [:asset, :expense] ->
          acc + e.amount

        # revenue | liablity -> credit increases, debit decreases
        %Entry{credit: ^id} when type in [:revenue, :liablity] ->
          acc + e.amount

        %Entry{debit: ^id} when type in [:revenue, :liablity] ->
          acc - e.amount

        _e ->
          acc
      end
    end
  end
end
