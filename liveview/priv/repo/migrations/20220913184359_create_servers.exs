defmodule LiveViewStudio.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers) do
      add :deploy_count, :integer
      add :framework, :string
      add :git_repo, :string
      add :last_commit_id, :string
      add :last_commit_message, :string
      add :name, :string
      add :size, :float
      add :status, :string

      timestamps()
    end

  end
end
