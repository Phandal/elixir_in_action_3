defmodule TodoList do
  defstruct next_id: 1, entries: %{}

  @type t :: %__MODULE__{}
  @type entry :: %{date: Date.t(), title: String.t()}

  @spec new(list(entry())) :: t()
  def new(entries \\ []) do
    Enum.reduce(
      entries,
      %__MODULE__{},
      &add_entry(&2, &1)
    )
  end

  @spec entries(t(), Date.t()):: list(entry())
  def entries(list, date) do
    list.entries
    |> Map.values()
    |> Enum.filter(fn entry -> entry.date == date end)
  end

  @spec add_entry(t(), entry()) :: t()
  def add_entry(list, entry) do
    entry = Map.put(entry, :id, list.next_id)
    %__MODULE__{
      next_id: list.next_id + 1,
      entries: Map.put(list.entries, list.next_id, entry)
    }
  end

  @spec update_entry(t(), pos_integer(), (entry -> entry)) :: t()
  def update_entry(list = %__MODULE__{}, id, updater) when is_number(id) do
    %__MODULE__{list | entries: Map.replace_lazy(list.entries, id, updater)}
  end

  @spec delete_entry(t(), pos_integer()) :: t()
  def delete_entry(list = %__MODULE__{}, id) when is_number(id) do
    %__MODULE__{list | entries: Map.delete(list.entries, id)}
  end
end

defmodule TodoList.CsvImporter do
  def import(path) do
    entries = File.stream!(path)
    |> Enum.map(&sanitize/1)

    TodoList.new(entries)
  end

  defp sanitize(line) do
    [date, title] = line
    |> String.trim
    |> String.split(",")

    %{date: Date.from_iso8601!(date), title: title}
  end
end

defimpl Collectable, for: TodoList do
  def into(initial) do
    {initial, &collector_callback/2}
  end

  defp collector_callback(list, {:cont, entry}) do
    TodoList.add_entry(list, entry)
  end
  
  defp collector_callback(list, :done), do: list
  defp collector_callback(_, :halt), do: :ok
end
