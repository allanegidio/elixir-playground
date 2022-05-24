defmodule ExMonApi.Pokemon.Get do
  alias ExMonApi.PokeApi.Client
  alias ExMonApi.Pokemon

  def call(name) do
    name
    |> Client.get_pokemon()
    |> handle_response()
  end

  defp handle_response({:ok, body}), do: {:ok, Pokemon.build(body)}

  defp handle_response({:error, reason}), do: {:error, reason}
end
