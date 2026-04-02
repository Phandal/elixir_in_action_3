defmodule TodoServer do
  def start(name), do: ServerProcess.start(__MODULE__, name)

  def add_entry(server, entry), do: ServerProcess.cast(server, {:add_entry, entry})

  def entries(server, date), do: ServerProcess.call(server, {:entries, date})
  
  def init(), do: TodoList.new()

  def handle_cast(state, {:add_entry, entry}), do: TodoList.add_entry(state, entry)

  def handle_call(state, _caller, {:entries, date}) do
    entries = TodoList.entries(state, date)
    {state, entries}
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

defmodule ServerProcess do
  def start(module, name) do
    spawn(fn ->
      Process.register(self(), name)
      initial_state = module.init()
      loop(module, initial_state)
    end)
  end

  def call(pid, request) do
    send(pid, {:call, self(), request})
    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, request) do
    send(pid, {:cast, request})
  end

  defp loop(module, state) do
    state =
      receive do
        message -> process_message(module, state, message)
      end

    loop(module, state)
  end

  defp process_message(module, state, {:call, caller, request}) do
    {state, response} = module.handle_call(state, caller, request)
    send(caller, {:response, response})
    state
  end

  defp process_message(module, state, {:cast, request}) do
    module.handle_cast(state, request)
  end
end
