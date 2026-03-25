defmodule TodoMap do
  alias TodoList.MultiDict
  
  @type entry :: %{ date: Date.t(), title: String.t()}
  
  @spec new() :: map()
  def new(), do: MultiDict.new()

  @spec add_entry(map(), entry()) :: map()
  def add_entry(list, %{date: date} = entry), do: MultiDict.update(list, date, entry)

  @spec entries(map(), Date.t()) :: list(entry())
  def entries(list, date), do: MultiDict.get(list, date)
end
