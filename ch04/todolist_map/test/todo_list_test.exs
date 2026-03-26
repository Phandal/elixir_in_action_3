defmodule TodoListTest do
  use ExUnit.Case

  test "full crud on TodoList entries" do
    list =
      TodoList.new([%{date: ~D[2025-03-25], title: "Old"}])
      |> TodoList.add_entry(%{date: ~D[2026-03-25], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2026-01-25], title: "Dinner"})
      |> TodoList.add_entry(%{date: ~D[2026-01-25], title: "Shopping"})

    assert [%{date: ~D[2025-03-25], title: "Old", id: 1}] ==
             TodoList.entries(list, ~D[2025-03-25])

    assert [%{date: ~D[2026-03-25], id: 2, title: "Updated"}] ==
             list
             |> TodoList.update_entry(2, fn entry -> %{entry | title: "Updated"} end)
             |> TodoList.entries(~D[2026-03-25])

    assert [] ==
             list
             |> TodoList.delete_entry(2)
             |> TodoList.entries(~D[2026-03-25])

  end

  test "todo csv importer" do
    list = TodoList.CsvImporter.import("#{__DIR__}/../todos.csv")

    assert [%{date: ~D[2018-12-20], title: "Shopping", id: 2}] ==
                      TodoList.entries(list, ~D[2018-12-20])
  end
end
