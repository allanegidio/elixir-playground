defmodule ExMonApi.Trainer.Pokemon.Update do
  alias ExMonApi.{Trainer.Pokemon, Repo}

  def call(%{"id" => id} = params) do
    case ExMonApi.fetch_trainer_pokemon(id) do
      {:error, reason} -> {:error, reason}
      {:ok, pokemon} -> update_pokemon(pokemon, params)
    end
  end

  def update_pokemon(pokemon, params) do
    pokemon
    |> Pokemon.update_changeset(params)
    |> Repo.update()
  end
end
