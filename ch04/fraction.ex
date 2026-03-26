defmodule Fraction do
  defstruct a: nil, b: nil

  def new(a, b), do: %__MODULE__{a: a, b: b}

  def value(%__MODULE__{a: a, b: b}), do: a / b

  def add(%Fraction{} = first, %Fraction{} = second) do
    newa = first.a * second.b + second.a * first.b
    newb = first.b * second.b

    %Fraction{a: newa, b: newb}
  end
end
