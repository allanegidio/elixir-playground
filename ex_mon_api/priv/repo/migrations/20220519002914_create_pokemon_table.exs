defmodule ExMonApi.Repo.Migrations.CreatePokemonTable do
  use Ecto.Migration

  def change do
    create table(:pokemon, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :nickname, :string
      add :weight, :integer
      add :types, {:array, :string}
      add :trainer_id, references(:trainer, type: :uuid, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
