defmodule TodoList.MultiDict do
  def update(list, date, entry), do: Map.update(list, date, [entry], &([entry | &1]))

  def get(list, date), do: Map.get(list, date, [])
end
