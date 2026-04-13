defmodule Todo.ListTest do
  use ExUnit.Case, async: true

  test "create and read" do
    list = 
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2026-04-12], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2026-04-12], title: "Shopping"})
      |> Todo.List.add_entry(%{date: ~D[2026-01-12], title: "Movies"})

    assert Todo.List.entries(list, ~D[2026-04-12]) == [
             %{date: ~D[2026-04-12], id: 1, title: "Dentist"},
             %{date: ~D[2026-04-12], id: 2, title: "Shopping"},
           ]
  end

  test "update and delete" do
    list = 
      Todo.List.new()
      |> Todo.List.add_entry(%{date: ~D[2026-04-12], title: "Dentist"})
      |> Todo.List.add_entry(%{date: ~D[2026-04-12], title: "Shopping"})
      |> Todo.List.add_entry(%{date: ~D[2026-01-12], title: "Movies"})
      |> Todo.List.update_entry(2, fn entry -> %{entry | title: "Updated"} end)
      |> Todo.List.delete_entry(1)

    assert Todo.List.entries(list, ~D[2026-04-12]) == [
             %{date: ~D[2026-04-12], id: 2, title: "Updated"},
           ]
  end

end
