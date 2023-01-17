defmodule AncestryPoc.Categories.Category do
  use Ecto.Schema
  import Ecto.Changeset

  use Arbor.Tree,
    foreign_key: :parent_id,
    foreign_key_type: :integer

  schema "categories" do
    field :description, :string
    field :name, :string
    belongs_to :parent, __MODULE__

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
