defmodule TodoListTest do
  use ExUnit.Case

  test "full crud on TodoList entries" do
    list =
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2026-03-25], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2026-01-25], title: "Dinner"})
      |> TodoList.add_entry(%{date: ~D[2026-01-25], title: "Shopping"})

    assert [%{date: ~D[2026-03-25], id: 1, title: "Updated"}] =
             list
             |> TodoList.update_entry(1, fn entry -> %{entry | title: "Updated"} end)
             |> TodoList.entries(~D[2026-03-25])

    assert [] =
             list
             |> TodoList.delete_entry(1)
             |> TodoList.entries(~D[2026-03-25])

  end
end
