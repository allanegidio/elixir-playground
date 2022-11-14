defmodule MultiStepForm.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :document, :string
      add :last_name, :string
      add :age, :integer

      timestamps()
    end
  end
end
