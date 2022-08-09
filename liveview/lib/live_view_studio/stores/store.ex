defmodule LiveViewStudio.Stores.Store do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stores" do
    field :city, :string
    field :hours, :string
    field :name, :string
    field :open, :boolean, default: false
    field :phone_number, :string
    field :street, :string
    field :zip, :string

    timestamps()
  end

  @doc false
  def changeset(store, attrs) do
    store
    |> cast(attrs, [:name, :street, :phone_number, :city, :zip, :open, :hours])
    |> validate_required([:name, :street, :phone_number, :city, :zip, :open, :hours])
  end
end
