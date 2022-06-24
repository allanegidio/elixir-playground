defmodule HandCards do
  def get_possible_pairs(ranks, suits) do
    for rank <- ranks, suit <- suits, do: {rank, suit}
  end

  def get_deck(cards) do
    Enum.take_random(cards, 13)
  end

  def get_hand(deck) do
    Enum.take_random(deck, 4)
  end
end

ranks = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
suits = ["♣", "♦", "♥", "♠"]

cards = HandCards.get_possible_pairs(ranks, suits)
deck = HandCards.get_deck(cards)
hand = HandCards.get_hand(deck)

IO.inspect(hand)
