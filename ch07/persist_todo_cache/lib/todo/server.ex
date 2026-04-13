defmodule Todo.Server do
  use GenServer

  def start(name), do: GenServer.start(__MODULE__, name)

  def add_entry(list, entry), do: GenServer.cast(list, {:add_entry, entry})

  def update_entry(list, entry, updater),
    do: GenServer.cast(list, {:update_entry, entry, updater})

  def delete_entry(list, entry), do: GenServer.cast(list, {:delete_entry, entry})

  def entries(list, date), do: GenServer.call(list, {:entries, date})

  @impl GenServer
  def init(name) do
    {:ok, {name, nil}, {:continue, :init}}
  end

  @impl GenServer
  def handle_continue(:init, {name, nil}) do
    list = Todo.Database.get(name) || Todo.List.new()
    {:noreply, {name, list}}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, {name, list}) do
    new_list = Todo.List.add_entry(list, entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_cast({:update_entry, id, updater}, {name, list}) do
    new_list = Todo.List.update_entry(list, id, updater)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_cast({:delete_entry, id}, {name, list}) do
    new_list = Todo.List.delete_entry(list, id)
    {:noreply, {name, new_list}}
  end

  @impl GenServer
  def handle_call({:entries, date}, _caller, {_name, list} = state) do
    entries = Todo.List.entries(list, date)
    {:reply, entries, state}
  end
end
