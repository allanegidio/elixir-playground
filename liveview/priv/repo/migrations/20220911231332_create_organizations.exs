defmodule LiveViewStudio.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :cnpj, :string

      add :address, :map
      add :contact, :map

      timestamps()
    end
  end
end
