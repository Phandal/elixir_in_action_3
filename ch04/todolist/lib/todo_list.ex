defmodule TodoList do
  alias TodoList.MultiDict
  
  @moduledoc """
  Simple TodoList to manage todos
  """

  @doc """
  Creates a new empty TodoList.
  """
  @spec new() :: map()
  def new do
    %{}
  end

  @doc """
  Adds an `entry` to the `list` with the `date`.
  """
  @spec add_entry(map(), Date.t(), String.t()) :: map()
  def add_entry(list, date, entry) do
    MultiDict.update(list, date, entry)
  end

  @doc """
  Gets all the entries for `date` from `list`.
  """
  @spec entries(map(), Date.t()) :: list(String.t())
  def entries(list, date) do
    MultiDict.get(list, date)
  end
end
