defmodule Playground.Doctests.Calculator do
  @moduledoc """
    Módulo da Calculadora
  """

  @doc ~S"""
  Sum first with second parameter

  ## Examples

      iex> Playground.Doctests.Calculator.sum(2, 2)
      4

  """
  def sum(a, b) do
    a + b
  end

  @doc ~S"""
  Sum first with second parameter

  ## Examples

      iex> Playground.Doctests.Calculator.subtract(2, 2)
      0

  """
  def subtract(a, b) do
    a - b
  end

  @doc ~S"""
  Sum first with second parameter

  ## Examples

      iex> Playground.Doctests.Calculator.divide(8, 2)
      4.0

  """
  def divide(a, b) do
    a / b
  end

  @doc ~S"""
  Sum first with second parameter

  ## Examples

      iex> Playground.Doctests.Calculator.multiplication(2, 2)
      4

  """
  def multiplication(a, b) do
    a * b
  end
end
