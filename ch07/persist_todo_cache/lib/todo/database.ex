defmodule Todo.Database do
  use GenServer

  def start do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.Database.Worker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.Database.Worker.get(key)
  end

  def reset(), do: GenServer.cast(__MODULE__, :reset)

  @impl GenServer
  def init(_) do
    {:ok, start_workers(3)}
  end

  @impl GenServer
  def handle_call({:choose_worker, name}, _from, workers) do
    index = :erlang.phash2(name, 3)
    worker = workers[index]

    {:reply, worker, workers}
  end

  @impl GenServer
  def handle_cast(:reset, workers) do
    Enum.each(workers, fn {_, worker} -> Todo.Database.Worker.reset(worker) end)

    {:noreply, workers}
  end

  defp choose_worker(name) do
    GenServer.call(__MODULE__, {:choose_worker, name})
  end

  defp start_workers(count) do
    for index <- 1..count, into: %{} do
      {:ok, worker} = Todo.Database.Worker.start("./persist" <> to_string(index))
      {index - 1, worker}
    end
  end
end
