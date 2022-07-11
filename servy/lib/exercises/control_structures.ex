defmodule ControlStructures do
  def ifao() do
    param = "Hello"

    if String.valid?(param) do
      "Valid string!"
    else
      "Invalid string."
    end
  end

  def ifao_negativo() do
    param = 12

    unless is_integer(param) do
      "Not an Int"
    end
  end

  def case(param) do
    case param do
      {:ok, result} -> result
      {:foo, bar} -> bar
      {:error} -> "Uh oh!"
      _ -> "Catch all"
    end
  end

  def pin(param) do
    should_be = "Precisa ser desse jeito"

    case param do
      ^should_be -> "Parabens voce fez certo."
      should_be -> should_be
    end
  end

  def case_with_guard(param) do
    case param do
      param when is_integer(param) ->
        "Funcinou lindamente, o resultado e  um inteiro."

      param when is_tuple(param) ->
        "Ta certo e uma tupla"

      _ ->
        "Nao achei nenhum resultado para voce"
    end
  end

  def cond(param) do
    cond do
      param == "CPF" ->
        "CPF tem 11 digitos"

      param == "CNPJ" ->
        "CNPJ tem 14 digitos"

      true ->
        "Esse true funciona quando nenhuma condicao acima e satisfeita"
    end
  end

  def with(param) do
    # case Map.fetch(param, :first) do
    #   {:ok, first} ->
    #     case Map.fetch(param, :last) do
    #       {:ok, last} ->
    #         last <> ", " <> first

    #       _error ->
    #         "Nao encontrou"
    #     end

    #   _error ->
    #     "Nao encontrou"
    # end

    with {:ok, first} <- Map.fetch(param, :first),
         {:ok, last} <- Map.fetch(param, :last) do
      last <> ", " <> first
    else
      :error -> "Deu ruim"
      _ -> "Foi muito ruim esse resultado"
    end
  end
end
