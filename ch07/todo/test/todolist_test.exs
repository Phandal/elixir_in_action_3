defmodule TodoListTest do
  use ExUnit.Case, async: true

  test "create and read" do
    list = 
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2026-04-12], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2026-04-12], title: "Shopping"})
      |> TodoList.add_entry(%{date: ~D[2026-01-12], title: "Movies"})

    assert TodoList.entries(list, ~D[2026-04-12]) == [
             %{date: ~D[2026-04-12], id: 1, title: "Dentist"},
             %{date: ~D[2026-04-12], id: 2, title: "Shopping"},
           ]
  end

  test "update and delete" do
    list = 
      TodoList.new()
      |> TodoList.add_entry(%{date: ~D[2026-04-12], title: "Dentist"})
      |> TodoList.add_entry(%{date: ~D[2026-04-12], title: "Shopping"})
      |> TodoList.add_entry(%{date: ~D[2026-01-12], title: "Movies"})
      |> TodoList.update_entry(2, fn entry -> %{entry | title: "Updated"} end)
      |> TodoList.delete_entry(1)

    assert TodoList.entries(list, ~D[2026-04-12]) == [
             %{date: ~D[2026-04-12], id: 2, title: "Updated"},
           ]
  end

end
