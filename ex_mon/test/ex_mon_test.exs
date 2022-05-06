defmodule ExMonTest do
  use ExUnit.Case
  doctest ExMon

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
