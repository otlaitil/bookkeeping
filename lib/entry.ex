defmodule Entry do
  @type t :: %Entry{debit: atom(), credit: atom(), amount: integer(), date: Date.t()}

  defstruct [:debit, :credit, :amount, :date]
end
