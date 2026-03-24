defmodule TodoListTest do
  use ExUnit.Case
  doctest TodoList

  test "adds entries and gets entries" do
    list =
      TodoList.new()
      |> TodoList.add_entry(~D[2026-03-23], "Dentist")
      |> TodoList.add_entry(~D[2026-01-23], "Shopping")
      |> TodoList.add_entry(~D[2026-03-23], "Movies")

    assert TodoList.entries(list, ~D[2026-03-23]) == ["Movies", "Dentist"]
    assert TodoList.entries(list, ~D[2026-01-23]) == ["Shopping"]
    assert TodoList.entries(list, :nil) == []
  end
end
