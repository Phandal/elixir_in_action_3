defmodule TodoMapTest do
  use ExUnit.Case, async: true

  test "adds and lists entries with a map" do
    list = TodoMap.new()
    |> TodoMap.add_entry(%{date: ~D[2026-03-24], title: "Dentist"})
    |> TodoMap.add_entry(%{date: ~D[2026-01-24], title: "Shopping"})
    |> TodoMap.add_entry(%{date: ~D[2026-03-24], title: "Movies"})

    assert TodoMap.entries(list, ~D[2026-01-24]) == [%{date: ~D[2026-01-24], title: "Shopping"}]
    assert TodoMap.entries(list, :nil) == []
  end
end
