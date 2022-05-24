defmodule ExMonApi.Trainer.Pokemon.Create do
  alias ExMonApi.PokeApi.Client
  alias ExMonApi.Pokemon
  alias ExMonApi.Trainer.Pokemon, as: TrainerPokemon
  alias ExMonApi.Repo

  def call(%{"name" => name} = params) do
    name
    |> Client.get_pokemon()
    |> handle_response(params)
  end

  defp handle_response({:ok, body}, params) do
    body
    |> Pokemon.build()
    |> create_pokemon(params)
  end

  defp handle_response({:error, reason}, _params), do: {:error, reason}

  defp create_pokemon(%Pokemon{name: name, weight: weight, types: types}, %{
         "nickname" => nickname,
         "trainer_id" => trainer_id
       }) do
    params = %{
      name: name,
      weight: weight,
      types: types,
      nickname: nickname,
      trainer_id: trainer_id
    }

    params
    |> TrainerPokemon.build()
    |> handle_build(trainer_id)
  end

  defp handle_build({:ok, pokemon}, trainer_id) do
    case ExMonApi.fetch_trainer(trainer_id) do
      {:error, reason} -> {:error, reason}
      {:ok, _trainer} -> Repo.insert(pokemon)
    end
  end

  defp handle_build({:error, reason}, _trainer_id), do: {:error, reason}
end
