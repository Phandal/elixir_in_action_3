defmodule TodoServer do
  def start() do
    spawn(fn ->
      state = TodoList.new()
      loop(state)
    end)
  end

  def add_entry(server, entry) do
    send(server, {:add_entry, entry})
  end

  def entries(server, date) do
    send(server, {:entries, self(), date})
    receive do
      {:response, entries} -> entries
    after
      5000 -> {:error, :timeout}
    end
  end

  defp loop(state) do
    state = receive do
      message -> process_message(state, message)
    end

    loop(state)
  end

  defp process_message(state, {:add_entry, entry}) do
    TodoList.add_entry(state, entry)
  end

  defp process_message(state, {:entries, caller, date}) do
    entries = TodoList.entries(state, date)
    send(caller, {:response, entries})
    state
  end
end

defmodule TodoList do
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

  def entries(list, date) do
    list.entries
    |> Map.values()
    |> Enum.filter(fn entry -> entry.date == date end)
  end
end
