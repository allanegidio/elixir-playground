defmodule FizzBuzzTest do
  use ExUnit.Case
  doctest FizzBuzz

  test "greets the world" do
    "bunda" |> IO.inspect()
    IO.inspect binding()
    assert FizzBuzz.hello() == :world
  end
end
