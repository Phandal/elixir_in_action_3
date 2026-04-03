defmodule TodoServer do
  use GenServer
  
  def start(entries \\ []), do: GenServer.start(__MODULE__, entries, name: __MODULE__)

  def add_entry(entry), do: GenServer.cast(__MODULE__, {:add_entry, entry})

  def entries(date), do: GenServer.call(__MODULE__ , {:entries, date})

  @impl GenServer
  def init(entries), do: {:ok, TodoList.new(entries)}

  @impl GenServer
  def handle_cast({:add_entry, entry}, state), do: {:noreply, TodoList.add_entry(state, entry)}

  @impl GenServer
  def handle_call({:entries, date}, _caller, state) do
    entries = TodoList.entries(state, date)
    {:reply, entries, state}
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
