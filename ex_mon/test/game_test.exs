defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}

  describe "start/2" do
    test "starts the game state" do
      player = Player.build("Allan", :chute, :soco, :cura)
      computer = Player.build("Egidio", :chute, :soco, :cura)

      assert {:ok, _pid} = Game.start(computer, player)
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      player = Player.build("Allan", :chute, :soco, :cura)
      computer = Player.build("Egidio", :chute, :soco, :cura)

      Game.start(computer, player)

      expected_info = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Egidio"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Allan"
        },
        status: :started,
        turn: :player
      }

      assert Game.info() == expected_info
    end
  end

  describe "update/1" do
    test "returns the game state updated" do
      player = Player.build("Allan", :chute, :soco, :cura)
      computer = Player.build("Egidio", :chute, :soco, :cura)

      Game.start(computer, player)

      expected_info = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Egidio"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Allan"
        },
        status: :started,
        turn: :player
      }

      assert Game.info() == expected_info

      updated_info = %{
        computer: %Player{
          life: 85,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Egidio"
        },
        player: %Player{
          life: 50,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Allan"
        },
        status: :started,
        turn: :player
      }

      Game.update(updated_info)

      expected_update_info = %{updated_info | turn: :computer, status: :continue}

      assert expected_update_info == Game.info()
    end
  end

  describe "player/0" do
    test "get player info" do
      player = Player.build("Allan", :chute, :soco, :cura)
      computer = Player.build("Egidio", :chute, :soco, :cura)

      Game.start(computer, player)

      player_info = Game.player()

      expected_player_info = %Player{
        life: 100,
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
        name: "Allan"
      }

      assert player_info == expected_player_info
    end
  end

  describe "turn/0" do
    test "get turn player" do
      player = Player.build("Allan", :chute, :soco, :cura)
      computer = Player.build("Egidio", :chute, :soco, :cura)

      Game.start(computer, player)

      assert Game.turn() == :player
    end

    test "get turn computer" do
      player = Player.build("Allan", :chute, :soco, :cura)
      computer = Player.build("Egidio", :chute, :soco, :cura)

      Game.start(computer, player)

      updated_info = %{
        computer: %Player{
          life: 85,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Egidio"
        },
        player: %Player{
          life: 50,
          moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute},
          name: "Allan"
        },
        status: :started,
        turn: :player
      }

      Game.update(updated_info)

      assert Game.turn() == :computer
    end
  end

  describe "fetch_player/1" do
    test "should return player" do
      player = Player.build("Allan", :chute, :soco, :cura)
      computer = Player.build("Egidio", :chute, :soco, :cura)

      Game.start(computer, player)

      assert Game.fetch_player(:player) == player
    end
  end
end
