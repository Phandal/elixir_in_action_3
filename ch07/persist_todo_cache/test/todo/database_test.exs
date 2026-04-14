defmodule Todo.DatabaseTest do
  use ExUnit.Case, async: true

  test "persistence" do
    Todo.Database.reset()
    {:ok, cache} = Todo.Cache.start()

    john = Todo.Cache.server_process(cache, "john")
    Todo.Server.add_entry(john, %{date: ~D[2026-04-13], title: "Dentist"})
    assert 1 == length(Todo.Server.entries(john, ~D[2026-04-13]))

    GenServer.stop(cache)
    {:ok, cache} = Todo.Cache.start()

    entries =
      cache
      |> Todo.Cache.server_process("john")
      |> Todo.Server.entries(~D[2026-04-13])

    assert [%{date: ~D[2026-04-13], title: "Dentist", id: 1}] = entries
  end
end
