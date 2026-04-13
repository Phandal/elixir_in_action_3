defmodule Todo.Server do
  use GenServer

  def start(entries \\ []), do: GenServer.start(__MODULE__, entries)

  def add_entry(list, entry), do: GenServer.cast(list, {:add_entry, entry})

  def update_entry(list, entry, updater), do: GenServer.cast(list, {:update_entry, entry, updater})

  def delete_entry(list, entry), do: GenServer.cast(list, {:delete_entry, entry})

  def entries(list, date), do: GenServer.call(list, {:entries, date})

  @impl GenServer
  def init(entries), do: {:ok, Todo.List.new(entries)}

  @impl GenServer
  def handle_cast({:add_entry, entry}, state), do: {:noreply, Todo.List.add_entry(state, entry)}

  @impl GenServer
  def handle_cast({:update_entry, id, updater}, state), do: {:noreply, Todo.List.update_entry(state, id, updater)}

  @impl GenServer
  def handle_cast({:delete_entry, id}, state), do: {:noreply, Todo.List.delete_entry(state, id)}

  @impl GenServer
  def handle_call({:entries, date}, _caller, state) do
    entries = Todo.List.entries(state, date)
    {:reply, entries, state}
  end
end
