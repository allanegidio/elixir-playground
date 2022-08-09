defmodule LiveViewStudio.GitRepos.GitRepo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "git_repos" do
    field :fork, :boolean, default: false
    field :language, :string
    field :license, :string
    field :name, :string
    field :owner_login, :string
    field :owner_url, :string
    field :stars, :integer
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(git_repo, attrs) do
    git_repo
    |> cast(attrs, [:name, :url, :owner_login, :owner_url, :language, :license, :fork, :stars])
    |> validate_required([:name, :url, :owner_login, :owner_url, :language, :license, :fork, :stars])
  end
end
