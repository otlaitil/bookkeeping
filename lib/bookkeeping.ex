defmodule Bookkeeping do
  defstruct [:ledgers, :entries]

  def start do
    unless Enum.member?(:ets.all(), :bookkeeping) do
      :ets.new(:bookkeeping, [:public, :named_table])
      :ets.insert(:bookkeeping, {:entries, []})
    end
  end

  def book(%Entry{} = entry) do
    [{_key, entries}] = :ets.lookup(:bookkeeping, :entries)
    :ets.insert(:bookkeeping, {:entries, [entry | entries]})
  end

  def account_balance(ledger, date) do
    [{_key, entries}] = :ets.lookup(:bookkeeping, :entries)

    entries
    |> filter_by_date(date)
    |> balance(ledger)
  end

  defp filter_by_date(entries, date) do
    Enum.filter(entries, fn %Entry{date: e_date} -> e_date <= date end)
  end

  defp balance(entries, ledger) do
    sum = fn
      e = %Entry{credit: ^ledger}, acc -> acc - e.amount
      e = %Entry{debit: ^ledger}, acc -> acc + e.amount
      _e, acc -> acc
    end

    Enum.reduce(entries, 0, sum)
  end
end
