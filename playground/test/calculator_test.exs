defmodule Playground.CalculatorTest do
  use ExUnit.Case, async: true
  # doctest Playground.Doctests.Calculator

  describe "sum/1" do
    test "should sum the arguments" do
      assert Playground.Doctests.Calculator.sum(2, 2) == 4
    end
  end

  describe "subtraction/1" do
    test "should subtract the arguments" do
      assert Playground.Doctests.Calculator.subtract(8, 4) == 4
    end
  end

  describe "divide/1" do
    test "should divide the arguments" do
      assert Playground.Doctests.Calculator.divide(16, 2) == 8.0
    end
  end

  describe "multiplication/1" do
    test "should multiplication the arguments" do
      assert Playground.Doctests.Calculator.multiplication(2, 2) == 4
    end
  end
end
