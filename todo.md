# TODO

* Lue kahdenkertainen kirjanpito dokkari
* Piirrä paperille pari transaktiota
* Tee elixir projekti

## Elixir projekti

* Entrypoint Bookkeeping.call

## DEA (double entry accounting)

```
class Ledger
  attr_accessor: :id, :name
end

class Entry
  attr_accessor: :id, :date, :debit_ledger_id, :credit_ledger_id, :sum
end
```
