defmodule LiveflashWeb.Organizations.Contact do
  use Ecto.Schema

  import Ecto.Changeset

  alias LiveflashWeb.Organizations.Contact

  embedded_schema do
    field :phone, :string
    field :website, :string
  end

  @doc false
  def changeset(%Contact{} = contact, attrs) do
    contact
    |> cast(attrs, [:website, :phone])
    |> validate_required([:website, :phone])
  end
end
