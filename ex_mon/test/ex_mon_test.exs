defmodule ExMonTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Game, Player}
  doctest ExMon

  describe "create_player/4" do
    test "create player" do
      expected_player = %ExMon.Player{
        life: 100,
        moves: %{
          move_avg: :smash,
          move_heal: :restore,
          move_rnd: :hyperbeam
        },
        name: "Onyx"
      }

      assert ExMon.create_player("Onyx", :smash, :hyperbeam, :restore) == expected_player
    end
  end

  describe "start_game/1" do
    test "should start the game" do
      player = ExMon.create_player("Onyx", :smash, :hyperbeam, :restore)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      assert messages =~ "The game is started!"
      assert messages =~ "status: :started"
      assert messages =~ "turn: :player"
    end
  end

  describe "make_move/1" do
    setup do
      player = ExMon.create_player("Onyx", :smash, :hyperbeam, :restore)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      :ok
    end

    test "when the move is valid, do the move and the computer makes a move" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:hyperbeam)
        end)

      assert messages =~ "The Player attacked the computer"
      assert messages =~ "The Computer attacked the player"
      assert messages =~ "It's computer turn"
      assert messages =~ "It's player turn"
      assert messages =~ "status: :continue"
    end
  end
end
