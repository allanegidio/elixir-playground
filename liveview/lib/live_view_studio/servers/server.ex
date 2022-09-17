defmodule LiveViewStudio.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  schema "servers" do
    field :deploy_count, :integer
    field :framework, :string
    field :git_repo, :string
    field :last_commit_id, :string
    field :last_commit_message, :string
    field :name, :string
    field :size, :float
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(server, attrs) do
    server
    |> cast(attrs, [:deploy_count, :framework, :git_repo, :last_commit_id, :last_commit_message, :name, :size, :status])
    |> validate_required([:deploy_count, :framework, :git_repo, :last_commit_id, :last_commit_message, :name, :size, :status])
  end
end
