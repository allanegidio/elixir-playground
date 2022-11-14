defmodule Liveflash.Organizations.Organization do
  use Ecto.Schema

  import Ecto.Changeset

  schema "organizations" do
    field :document, :string
    field :name, :string
    field :last_name, :string
    field :age, :integer

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :document, :last_name, :age])
    |> validate_required([:name, :document, :last_name, :age])
  end
end
