defmodule ExMonApi.Trainer.Pokemon.Get do
  alias ExMonApi.{Trainer.Pokemon, Repo}
  alias Ecto.UUID

  def call(id) do
    case UUID.cast(id) do
      :error -> {:error, %{message: "Invalid ID format!", status: 400}}
      {:ok, uuid} -> get(uuid)
    end
  end

  def get(uuid) do
    case Repo.get(Pokemon, uuid) do
      nil -> {:error, %{message: "Trainer not found!", status: 404}}
      pokemon -> {:ok, Repo.preload(pokemon, :trainer)}
    end
  end
end
