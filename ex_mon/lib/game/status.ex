defmodule ExMon.Game.Status do
  alias ExMon.Game

  def print_round_message() do
    IO.puts("\n ============ The game is started! ============ \n")
    IO.inspect(Game.info())
    IO.puts("---------------------------")
  end

  def print_wrong_move_message(movement) do
    IO.puts("\n ============ Invalid Movement: #{movement}. ============ \n")
  end
end
