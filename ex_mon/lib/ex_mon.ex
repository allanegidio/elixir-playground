defmodule ExMon do
  alias ExMon.{Game, Player}
  alias ExMon.Game.{Actions, Status}

  @computer_name "Pikachu"
  @computer_moves [:move_rnd, :move_avg, :move_heal]

  def create_player(name, move_avg, move_rnd, move_heal) do
    Player.build(name, move_rnd, move_avg, move_heal)
  end

  def start_game(player) do
    @computer_name
    |> ExMon.create_player(:punch, :thunderbolt, :heal)
    |> Game.start(player)

    Game.info()
    |> Status.print_round_message()
  end

  def make_move(movement) do
    Game.info()
    |> Map.get(:status)
    |> handle_status(movement)
  end

  defp handle_status(:game_over, _movement), do: Status.print_round_message(Game.info())

  defp handle_status(_status, movement) do
    movement
    |> Actions.fetch_move()
    |> do_move()

    computer_move(Game.info())
  end

  defp do_move({:error, movement}) do
    Status.print_wrong_move_message(movement)
  end

  defp do_move({:ok, movement}) do
    case movement do
      :move_heal -> Actions.heal()
      movement -> Actions.attack(movement)
    end

    Game.info()
    |> Status.print_round_message()
  end

  defp computer_move(%{turn: :computer, status: :continue}) do
    move = {:ok, Enum.random(@computer_moves)}
    do_move(move)
  end

  defp computer_move(_), do: :ok
end
