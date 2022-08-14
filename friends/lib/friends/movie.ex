defmodule Friends.Movie do
  use Ecto.Schema

  schema "movies" do
    field(:title, :string)
    field(:tagline, :string)
    has_many(:characters, Friends.Character)
    has_one(:distributor, Friends.Distributor)
  end
end
