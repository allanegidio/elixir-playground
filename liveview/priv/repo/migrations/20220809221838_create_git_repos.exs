defmodule LiveViewStudio.Repo.Migrations.CreateGitRepos do
  use Ecto.Migration

  def change do
    create table(:git_repos) do
      add :name, :string
      add :url, :string
      add :owner_login, :string
      add :owner_url, :string
      add :language, :string
      add :license, :string
      add :fork, :boolean, default: false, null: false
      add :stars, :integer

      timestamps()
    end

  end
end
