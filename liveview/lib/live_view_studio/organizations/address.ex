defmodule LiveViewStudio.Organization.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveViewStudio.Organization.Address

  embedded_schema do
    field :city, :string
    field :postal_code, :string
    field :primary_address, :string
    field :state, :string
  end

  @doc false
  def changeset(%Address{} = address, attrs) do
    address
    |> cast(attrs, [:postal_code, :primary_address, :state, :city])
    |> validate_required([:postal_code, :primary_address, :state, :city])
  end
end
