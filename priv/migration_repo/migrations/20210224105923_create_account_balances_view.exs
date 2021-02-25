defmodule Bookkeeping.Repo.Migrations.CreateAccountBalancesView do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE MATERIALIZED VIEW app.account_balances(
              -- Materialized so financial reports run fast.
              -- Modification of accounts and entries will require a
              -- REFRESH MATERIALIZED VIEW, which we can trigger
              -- automatically.
              account_id, -- INTEGER REFERENCES accounts(id) NOT NULL UNIQUE
              balance -- NUMERIC NOT NULL
      ) AS
      SELECT
              accounts.id,
              COALESCE(sum(account_ledgers.amount), 0)
      FROM
              app.accounts
              LEFT OUTER JOIN app.account_ledgers
              ON accounts.id = account_ledgers.account_id
      GROUP BY accounts.id;
      """,
      "DROP MATERIALIZED VIEW app.account_balances;"
    )

    create(index("account_balances", [:account_id], unique: true, prefix: :app))

    execute(
      """
      CREATE FUNCTION update_balances() RETURNS TRIGGER
      SECURITY DEFINER
      AS $$
      BEGIN
              REFRESH MATERIALIZED VIEW app.account_balances;
              RETURN NULL;
      END
      $$ LANGUAGE plpgsql;
      """,
      "DROP FUNCTION app.update_balances;"
    )

    execute(
      """
      CREATE TRIGGER trigger_fix_balance_entries
      AFTER INSERT
      OR UPDATE OF amount, credit_id, debit_id
      OR DELETE OR TRUNCATE
      ON app.entries
      FOR EACH STATEMENT
      EXECUTE PROCEDURE update_balances();
      """,
      "DROP TRIGGER trigger_fix_balance_entries ON entries;"
    )

    execute(
      """
      CREATE TRIGGER trigger_fix_balance_accounts
      AFTER INSERT
      OR UPDATE OF id
      OR DELETE OR TRUNCATE
      ON app.accounts
      FOR EACH STATEMENT
      EXECUTE PROCEDURE update_balances();
      """,
      "DROP TRIGGER app.trigger_fix_balance_accounts ON accounts;"
    )

    execute(
      """
      GRANT ALL ON app.account_balances TO app;
      """,
      ""
    )
  end
end
