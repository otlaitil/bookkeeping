defmodule Ledger do
  defstruct [:id, :type, :name]

  @type ledger_variant :: :asset | :revenue | :liablity | :expense
  @type t :: %Ledger{id: atom(), type: ledger_variant(), name: String.t()}

  @spec bank_account :: Ledger.t()
  def bank_account do
    %Ledger{id: :bank, type: :asset, name: "Bank Account"}
  end

  @spec trade_receivables :: Ledger.t()
  def trade_receivables do
    %Ledger{id: :trade_receivables, type: :asset, name: "Myyntisaamiset"}
  end

  @spec sales :: Ledger.t()
  def sales do
    %Ledger{id: :sales, type: :revenue, name: "Myynnit ALV 24%"}
  end

  @spec payable_vat :: Ledger.t()
  def payable_vat do
    %Ledger{id: :vats, type: :liablity, name: "Maksettava ALV"}
  end

  @spec salaries :: Ledger.t()
  def salaries do
    %Ledger{id: :salaries, type: :expense, name: "Palkat"}
  end
end
