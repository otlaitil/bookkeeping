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
    |> filter_by_date(date)
    |> balance(ledger)
  end

  defp filter_by_date(entries, date) do
    Enum.filter(entries, fn %Entry{date: e_date} -> e_date <= date end)
  end

  # see credits and debits chart from
  # https://bit.ly/3aILqs9
  defp balance(entries, %Ledger{id: id, type: type}) do
    sum_fn = fn
      e, acc ->
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

    Enum.reduce(entries, 0, sum_fn)
  end
end
