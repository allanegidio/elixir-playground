defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "greets the world" do
    assert Cards.hello() == "Allan, The Alchemist!"
  end

  test "create_deck makes 20 cards" do
    deck_length = length(Cards.create_deck)
    assert deck_length == 20
  end

  test "shufflinh a deck randomizes it" do
    deck = Cards.create_deck
    # assert deck != Cards.shuffle(deck)
    refute deck == Cards.shuffle(deck)
  end
end
