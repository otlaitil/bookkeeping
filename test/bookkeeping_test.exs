defmodule BookkeepingTest do
  use ExUnit.Case
  doctest Bookkeeping

  setup do
    {:ok, salaries} =
      Bookkeeping.Repo.insert(%Bookkeeping.Ledger{
        name: "Salaries",
        type: "expense"
      })

    {:ok, sales} =
      Bookkeeping.Repo.insert(%Bookkeeping.Ledger{
        name: "Sales",
        type: "revenue"
      })

    {:ok, trade_receivables} =
      Bookkeeping.Repo.insert(%Bookkeeping.Ledger{
        name: "Trade Receivables",
        type: "asset"
      })

    {:ok, bank} =
      Bookkeeping.Repo.insert(%Bookkeeping.Ledger{
        name: "Bank Account",
        type: "asset"
      })

    {:ok, payable_vat} =
      Bookkeeping.Repo.insert(%Bookkeeping.Ledger{
        name: "Payable VAT",
        type: "liablity"
      })

    # 1. A sale of 1000 EUR + VAT 24 % = 1240 EUR, 1.1.2021
    Bookkeeping.book(%{
      debit_id: trade_receivables.id,
      credit_id: sales.id,
      date: ~U[2021-01-01 00:00:00Z],
      amount: 1000_00
    })

    Bookkeeping.book(%{
      debit_id: trade_receivables.id,
      credit_id: payable_vat.id,
      date: ~U[2021-01-01 00:00:00Z],
      amount: 240_00
    })

    # 2. Customer pays the bill of 1240 EUR, 7.1.2021
    Bookkeeping.book(%{
      debit_id: bank.id,
      credit_id: trade_receivables.id,
      date: ~U[2021-01-07 00:00:00Z],
      amount: 1240_00
    })

    # 3. Paying salary of 950 EUR to user, 8.1.2021
    Bookkeeping.book(%{
      debit_id: salaries.id,
      credit_id: bank.id,
      date: ~U[2021-01-08 00:00:00Z],
      amount: 950_00
    })

    %{
      sales: sales,
      payable_vat: payable_vat,
      trade_receivables: trade_receivables,
      salaries: salaries,
      bank: bank,
      date: ~U[2021-12-31 00:00:00Z]
    }
  end

  test "sales", %{sales: sales, date: date} do
    balance = Bookkeeping.account_balance(sales, date)
    assert balance == 1000_00
  end

  test "payable vat", %{payable_vat: payable_vat, date: date} do
    balance = Bookkeeping.account_balance(payable_vat, date)
    assert balance == 240_00
  end

  test "bank account", %{bank: bank, date: date} do
    balance = Bookkeeping.account_balance(bank, date)
    assert balance == 290_00
  end

  test "trade receivables", %{trade_receivables: trade_receivables, date: date} do
    balance = Bookkeeping.account_balance(trade_receivables, date)
    assert balance == 0
  end

  test "salaries", %{salaries: salaries, date: date} do
    balance = Bookkeeping.account_balance(salaries, date)
    assert balance == 950_00
  end
end
