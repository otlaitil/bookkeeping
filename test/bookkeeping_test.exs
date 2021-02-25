defmodule BookkeepingTest do
  use Bookkeeping.RepoCase
  alias Bookkeeping.Factory

  doctest Bookkeeping

  setup do
    salaries =
      Factory.insert!(:account, %{
        name: "Salaries",
        type: "expense"
      })

    sales =
      Factory.insert!(:account, %{
        name: "Sales",
        type: "revenue"
      })

    trade_receivables =
      Factory.insert!(:account, %{
        name: "Trade Receivables",
        type: "asset"
      })

    bank =
      Factory.insert!(:account, %{
        name: "Bank Account",
        type: "asset"
      })

    payable_vat =
      Factory.insert!(:account, %{
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
      bank: bank
    }
  end

  test "sales", %{sales: sales} do
    balance = Bookkeeping.account_balance(sales)
    assert balance == 1000_00
  end

  test "payable vat", %{payable_vat: payable_vat} do
    balance = Bookkeeping.account_balance(payable_vat)
    assert balance == 240_00
  end

  test "bank account", %{bank: bank} do
    balance = Bookkeeping.account_balance(bank)
    assert balance == 290_00
  end

  test "trade receivables", %{trade_receivables: trade_receivables} do
    balance = Bookkeeping.account_balance(trade_receivables)
    assert balance == 0
  end

  test "salaries", %{salaries: salaries} do
    balance = Bookkeeping.account_balance(salaries)
    assert balance == 950_00
  end
end
