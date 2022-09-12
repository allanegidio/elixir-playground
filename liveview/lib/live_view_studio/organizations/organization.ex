defmodule LiveViewStudio.Organizations.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveViewStudio.Organization.Address
  alias LiveViewStudio.Organization.Contact

  schema "organizations" do
    field :cnpj, :string
    field :name, :string

    embeds_one :address, Address
    embeds_one :contact, Contact

    timestamps()
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :cnpj])
    |> validate_required([:name, :cnpj])
    |> cast_embed(:address, required: true)
    |> cast_embed(:contact, required: true)
  end
end
