defmodule Todo.ServerTest do
  use ExUnit.Case, async: true

  test "to-do operations" do
    Todo.Database.reset()
    {:ok, cache} = Todo.Cache.start()

    alice = Todo.Cache.server_process(cache, "alice")
    Todo.Server.add_entry(alice, %{date: ~D[2026-04-12], title: "Dentist"})

    entries = Todo.Server.entries(alice, ~D[2026-04-12])
    assert [%{date: ~D[2026-04-12], title: "Dentist", id: 1}] = entries
  end
end
