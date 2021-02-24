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
                  CASE WHEN accounts.type = 'asset' then
                    (0 - entries.amount)
                  WHEN accounts.type = 'expense' then
                    (0 - entries.amount)
                  ELSE
                    entries.amount
                  END
          FROM
                  entries
          INNER JOIN accounts
          ON accounts.id = entries.credit_id

          UNION ALL

          SELECT
                  entries.debit_id,
                  entries.id,
                  CASE WHEN accounts.type = 'asset' then
                    entries.amount
                  WHEN accounts.type = 'expense' then
                    entries.amount
                  ELSE
                    (0 - entries.amount)
                  END
          FROM
                  entries
          INNER JOIN accounts
          ON accounts.id = entries.debit_id;
      """,
      ""
    )
  end
end
