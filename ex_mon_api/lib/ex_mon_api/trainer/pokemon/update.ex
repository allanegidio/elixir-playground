defmodule ExMonApi.Trainer.Pokemon.Update do
  alias Ecto.UUID
  alias ExMonApi.{Trainer.Pokemon, Repo}

  def call(%{"id" => id} = params) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format!"}
      {:ok, _uuid} -> update(params)
    end
  end

  defp update(%{"id" => id} = params) do
    case fetch_pokemon(id) do
      nil -> {:error, "Trainer not found!"}
      pokemon -> update_pokemon(pokemon, params)
    end
  end

  defp fetch_pokemon(id), do: Repo.get(Pokemon, id)

  def update_pokemon(pokemon, params) do
    pokemon
    |> Pokemon.update_changeset(params)
    |> Repo.update()
  end
end
