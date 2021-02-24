defmodule Bookkeeping.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Bookkeeping.Repo

      import Ecto
      import Ecto.Query
      import Bookkeeping.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Bookkeeping.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Bookkeeping.Repo, {:shared, self()})
    end

    :ok
  end
end
