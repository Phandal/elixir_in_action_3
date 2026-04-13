defmodule Todo.List do
  defstruct next_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %__MODULE__{},
      &add_entry(&2, &1)
    )
  end

  def add_entry(list, entry) do
    entry = Map.put(entry, :id, list.next_id)

    %__MODULE__{
      next_id: list.next_id + 1,
      entries: Map.put(list.entries, list.next_id, entry)
    }
  end

  def update_entry(list, id, updater) do
    list = %__MODULE__{} = list
    entries = Map.replace_lazy(list.entries, id, updater)

    %__MODULE__{list | entries: entries}
  end

  def delete_entry(list, id) do
    list = %__MODULE__{} = list
    entries = Map.drop(list.entries, [id])
    
    %__MODULE__{list | entries: entries}
  end

  def entries(list, date) do
    list.entries
    |> Map.values()
    |> Enum.filter(fn entry -> entry.date == date end)
  end
end
