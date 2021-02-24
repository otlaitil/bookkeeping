defmodule Bookkeeping.Repo.Migrations.CreateAccountBalancesView do
  use Ecto.Migration

  def change do
    execute(
      """
      CREATE MATERIALIZED VIEW account_balances(
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
              accounts
              LEFT OUTER JOIN account_ledgers
              ON accounts.id = account_ledgers.account_id
      GROUP BY accounts.id;
      """,
      "DROP MATERIALIZED VIEW account_balances;"
    )

    create(index("account_balances", [:account_id], unique: true))

    execute(
      """
      CREATE FUNCTION update_balances() RETURNS TRIGGER AS $$
      BEGIN
              REFRESH MATERIALIZED VIEW account_balances;
              RETURN NULL;
      END
      $$ LANGUAGE plpgsql;
      """,
      "DROP FUNCTION update_balances;"
    )

    execute(
      """
      CREATE TRIGGER trigger_fix_balance_entries
      AFTER INSERT
      OR UPDATE OF amount, credit_id, debit_id
      OR DELETE OR TRUNCATE
      ON entries
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
      ON accounts
      FOR EACH STATEMENT
      EXECUTE PROCEDURE update_balances();
      """,
      "DROP TRIGGER trigger_fix_balance_accounts ON accounts;"
    )
  end
end
