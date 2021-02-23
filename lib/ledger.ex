defmodule Ledger do
  defstruct [:id, :type, :name]

  def bank_account do
    %Ledger{id: :bank, type: :asset, name: "Bank Account"}
  end

  def trade_receivables do
    %Ledger{id: :trade_receivables, type: :asset, name: "Myyntisaamiset"}
  end

  def sales do
    %Ledger{id: :sales, type: :revenue, name: "Myynnit ALV 24%"}
  end

  def payable_vat do
    %Ledger{id: :vats, type: :liablity, name: "Maksettava ALV"}
  end

  def salaries do
    %Ledger{id: :salaries, type: :expense, name: "Palkat"}
  end
end
