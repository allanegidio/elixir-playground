defmodule ExMonApi.Trainer.Pokemon.Delete do
  alias ExMonApi.Repo

  def call(id) do
    case ExMonApi.fetch_trainer_pokemon(id) do
      {:error, reason} -> {:error, reason}
      {:ok, pokemon} -> delete(pokemon)
    end
  end

  defp delete(pokemon), do: Repo.delete(pokemon)
end
