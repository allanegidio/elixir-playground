defmodule AncestryPoc.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :description, :string
      add :parent_id, references(:categories), null: true

      timestamps()
    end

    create index(:categories, [:parent_id])
  end
end
