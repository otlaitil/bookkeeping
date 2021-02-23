defmodule BookkeepingTest do
  use ExUnit.Case
  doctest Bookkeeping

  setup do
    Bookkeeping.start()

    # 1. A sale of 1000 EUR + VAT 24 % = 1240 EUR, 1.1.2021
    date = ~D[2021-01-01]

    sale_1 = %Entry{
      debit: Ledger.trade_receivables().id,
      credit: Ledger.sales().id,
      amount: 1000,
      date: date
    }

    sale_1_vat = %Entry{
      debit: Ledger.trade_receivables().id,
      credit: Ledger.payable_vat().id,
      amount: 240,
      date: date
    }

    Bookkeeping.book(sale_1)
    Bookkeeping.book(sale_1_vat)

    # 2. Customer pays the bill of 1240 EUR, 7.1.2021
    date = ~D[2021-01-07]

    received_payment_1 = %Entry{
      debit: Ledger.bank_account().id,
      credit: Ledger.trade_receivables().id,
      amount: 1240,
      date: date
    }

    Bookkeeping.book(received_payment_1)

    # 3. Paying salary of 950 EUR to user on 8.1.2021
    date = ~D[2021-01-08]

    outgoing_payment_1 = %Entry{
      debit: Ledger.salaries().id,
      credit: Ledger.bank_account().id,
      amount: 950,
      date: date
    }

    Bookkeeping.book(outgoing_payment_1)

    closing_date = ~D[2021-12-31]
    %{date: closing_date}
  end

  test "sales", %{date: date} do
    assert Bookkeeping.account_balance(Ledger.sales(), date) == 1000
  end

  test "payable vats", %{date: date} do
    assert Bookkeeping.account_balance(Ledger.payable_vat(), date) == 240
  end

  test "bank account", %{date: date} do
    assert Bookkeeping.account_balance(Ledger.bank_account(), date) == 290
  end

  test "trade receivables", %{date: date} do
    assert Bookkeeping.account_balance(Ledger.trade_receivables(), date) == 0
  end

  test "salaries", %{date: date} do
    assert Bookkeeping.account_balance(Ledger.salaries(), date) == 950
  end
end
