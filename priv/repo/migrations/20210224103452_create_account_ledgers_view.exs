defmodule Bookkeeping.Repo.Migrations.CreateAccountLedgersView do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE VIEW account_ledgers(
          account_id,
          entry_id,
          amount
      ) AS
          SELECT
                  entries.credit_id,
                  entries.id,
                  (0 - entries.amount)
          FROM
                  entries
          UNION ALL
          SELECT
                  entries.debit_id,
                  entries.id,
                  entries.amount
          FROM
                  entries;

      """,
      ""
    )
  end
end
