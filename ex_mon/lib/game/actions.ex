defmodule ExMon.Game.Actions do
  alias ExMon.Game

  def fetch_move(movement) do
    Game.player()
    |> Map.get(:moves)
    |> find_move(movement)
  end

  def attack(movement) do
  end

  def heal do
    "Realiza cura"
  end

  defp find_move(movements, movement) do
    Enum.find_value(movements, {:error, movement}, fn {key, value} ->
      if(value == movement) do
        {:ok, key}
      end
    end)
  end
end
