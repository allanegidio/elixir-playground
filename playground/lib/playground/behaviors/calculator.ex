defmodule Playground.Behaviors.Calculator do
  @behaviour Playground.Behaviors.Calculation

  @impl Playground.Behaviors.Calculation
  def sum(a, b) when is_integer(a) and is_integer(b) do
    {:ok, a + b}
  end

  def sum(_a, _b) do
    {:erro, "Nao e um inteiro"}
  end

  def subtract(a, b) do
    {:ok, a - b}
  end
end
