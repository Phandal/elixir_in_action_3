# iex(1)> calculator_pid = Calculator.start()      ❶
#  
# iex(2)> Calculator.value(calculator_pid)         ❷
# 0                                                ❷
#  
# iex(3)> Calculator.add(calculator_pid, 10)       ❸
# iex(4)> Calculator.sub(calculator_pid, 5)        ❸
# iex(5)> Calculator.mul(calculator_pid, 3)        ❸
# iex(6)> Calculator.div(calculator_pid, 5)        ❸
#  
# iex(7)> Calculator.value(calculator_pid)         ❹
# 3.0

defmodule Calculator do
  @moduledoc """
  Basic calculator with statuful server
  """

  @spec start() :: pid()
  def start do
    spawn(fn ->
      state = 0
      loop(state)
    end)
  end

  @spec add(pid(), number()) :: pid()
  def add(server_pid, value) do
    send(server_pid, {:add, value})
  end

  def sub(server_pid, value) do
    send(server_pid, {:sub, value})
  end

  def mul(server_pid, value) do
    send(server_pid, {:mul, value})
  end

  def div(server_pid, value) do
    send(server_pid, {:div, value})
  end

  def value(server_pid) do
    send(server_pid, {:value, self()})

    receive do
      {:response, value} -> value
    end
  end

  @spec loop(number()) :: no_return()
  defp loop(state) do
    state =
      receive do
        message -> process_message(state, message)
      end

    loop(state)
  end

  defp process_message(state, {:add, value}), do: state + value
  defp process_message(state, {:sub, value}), do: state - value
  defp process_message(state, {:mul, value}), do: state * value
  defp process_message(state, {:div, value}), do: state / value

  defp process_message(state, {:value, caller}) do
    send(caller, {:response, state})
    state
  end

  defp process_message(state, invalid) do
    IO.puts("invalid request #{inspect(invalid)}")
    state
  end
end
