defmodule NaturalNums do
  def print(1), do: IO.puts(1)

  def print(n) when n <= 0 do
    IO.puts(n)
  end

  def print(n) do
    print(n - 1)
    IO.puts(n)
  end
end
