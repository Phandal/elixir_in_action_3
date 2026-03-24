defmodule Lines do
  def length(path) do
    File.stream!(path)
    |> Enum.map(&String.length/1)
  end

  def longest_length(path) do
    File.stream!(path)
    |> Stream.map(&String.length/1)
    |> Enum.max()
  end

  def longest(path) do
    File.stream!(path)
    |> Enum.max_by(&String.length/1)
  end

  def words_per(path) do
    File.stream!(path)
    |> Enum.map(&Kernel.length(String.split(&1)))
  end
end
