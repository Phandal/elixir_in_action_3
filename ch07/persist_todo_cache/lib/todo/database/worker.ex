defmodule Todo.Database.Worker do
  use GenServer

  def start(path) do
    GenServer.start(__MODULE__, path)
  end

  def store(worker, key, data), do: GenServer.cast(worker, {:store, key, data})

  def get(worker, key), do: GenServer.call(worker, {:get, key})

  def reset(worker), do: GenServer.cast(worker, :reset)

  @impl GenServer
  def init(path) do
    File.mkdir_p(path)
    {:ok, path}
  end

  @impl GenServer
  def handle_cast({:store, key, value}, path) do
    file_name(path, key)
    |> File.write!(:erlang.term_to_binary(value))

    IO.puts("store in worker_pid #{inspect(self())}")
    {:noreply, path}
  end

  @impl GenServer
  def handle_cast(:reset, path) do
    {:ok, files} = File.ls(path)
    Enum.each(files, fn file -> File.rm(file_name(path, file)) end)

    IO.puts("reset in worker_pid #{inspect(self())}")
    {:noreply, path}
  end

  @impl GenServer
  def handle_call({:get, key}, _from, path) do
    data =
      case File.read(file_name(path, key)) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    IO.puts("get in worker_pid #{inspect(self())}")
    {:reply, data, path}
  end

  defp file_name(path, folder) do
    Path.join(path, to_string(folder))
  end
end
