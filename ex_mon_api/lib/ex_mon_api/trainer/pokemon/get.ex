defmodule ExMonApi.Trainer.Pokemon.Get do
  alias ExMonApi.{Trainer.Pokemon, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, "Invalid ID format!"}
      {:ok, uuid} -> get(uuid)
    end
  end

  def get(uuid) do
    case Repo.get(Pokemon, uuid) do
      nil -> {:error, "Pokemon not found!"}
      pokemon -> {:ok, Repo.preload(pokemon, :trainer)}
    end
  end
end
