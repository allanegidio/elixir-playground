defmodule LiveViewStudio.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add :name, :string
      add :street, :string
      add :phone_number, :string
      add :city, :string
      add :zip, :string
      add :open, :boolean, default: false, null: false
      add :hours, :string

      timestamps()
    end

  end
end
