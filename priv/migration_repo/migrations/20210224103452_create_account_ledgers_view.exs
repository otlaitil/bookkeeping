defmodule Bookkeeping.Repo.Migrations.CreateAccountLedgersView do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE VIEW app.account_ledgers(
          account_id,
          entry_id,
          amount
      ) AS
          SELECT
                  entries.credit_id,
                  entries.id,
                  (0 - entries.amount)
          FROM
                  app.entries
          INNER JOIN app.accounts
          ON accounts.id = app.entries.credit_id

          UNION ALL

          SELECT
                  entries.debit_id,
                  entries.id,
                  entries.amount
          FROM
                  app.entries
          INNER JOIN app.accounts
          ON accounts.id = entries.debit_id;
      """,
      ""
    )

    execute(
      """
      GRANT ALL ON app.account_ledgers TO app;
      """,
      ""
    )
  end
end
