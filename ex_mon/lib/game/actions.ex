defmodule ExMon.Game.Actions do
  alias ExMon.Game
  alias ExMon.Game.Actions.Attack

  def fetch_move(movement) do
    Game.player()
    |> Map.get(:moves)
    |> find_move(movement)
  end

  def attack(movement) do
    case Game.turn() do
      :player -> Attack.attack_opponent(:computer, movement)
      :computer -> Attack.attack_opponent(:player, movement)
    end
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
