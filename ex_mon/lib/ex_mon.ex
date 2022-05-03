defmodule ExMon do
  alias ExMon.{Game, Player}
  alias ExMon.Game.{Actions, Status}

  @computer_name "Pikachu"

  def create_player(name, move_avg, move_rnd, move_heal) do
    Player.build(name, move_rnd, move_avg, move_heal)
  end

  def start_game(player) do
    @computer_name
    |> ExMon.create_player(:punch, :thunderbolt, :heal)
    |> Game.start(player)

    Status.print_round_message()
  end

  def make_move(movement) do
    movement
    |> Actions.fetch_move()
    |> do_move()
  end

  defp do_move({:error, movement}) do
    Status.print_wrong_move_message(movement)
  end

  defp do_move({:ok, movement}) do
    case movement do
      :move_heal -> Actions.heal()
      movement -> Actions.attack(movement)
    end
  end
end
