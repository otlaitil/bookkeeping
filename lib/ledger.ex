defmodule Ledger do
  defstruct [:id, :name]

  def bank_account do
    %Ledger{id: :bank, name: "Bank Account"}
  end

  def trade_receivables do
    %Ledger{id: :trade_receivables, name: "Myyntisaamiset"}
  end

  def sales do
    %Ledger{id: :sales, name: "Myynnit ALV 24%"}
  end

  def payable_vat do
    %Ledger{id: :vats, name: "Maksettava ALV"}
  end

  def salaries do
    %Ledger{id: :salaries, name: "Palkat"}
  end
end
