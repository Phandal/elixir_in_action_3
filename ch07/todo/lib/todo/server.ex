defmodule TodoServer do
  use GenServer

  def start(entries \\ []), do: GenServer.start(__MODULE__, entries, name: __MODULE__)

  def add_entry(entry), do: GenServer.cast(__MODULE__, {:add_entry, entry})

  def update_entry(entry, updater), do: GenServer.cast(__MODULE__, {:update_entry, entry, updater})

  def delete_entry(entry), do: GenServer.cast(__MODULE__, {:delete_entry, entry})

  def entries(date), do: GenServer.call(__MODULE__, {:entries, date})

  @impl GenServer
  def init(entries), do: {:ok, TodoList.new(entries)}

  @impl GenServer
  def handle_cast({:add_entry, entry}, state), do: {:noreply, TodoList.add_entry(state, entry)}

  @impl GenServer
  def handle_cast({:update_entry, id, updater}, state), do: {:noreply, TodoList.update_entry(state, id, updater)}

  @impl GenServer
  def handle_cast({:delete_entry, id}, state), do: {:noreply, TodoList.delete_entry(state, id)}

  @impl GenServer
  def handle_call({:entries, date}, _caller, state) do
    entries = TodoList.entries(state, date)
    {:reply, entries, state}
  end
end
