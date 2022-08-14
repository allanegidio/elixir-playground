defmodule Friends.Actor do
  use Ecto.Schema

  schema "actors" do
    field(:name, :string)
    many_to_many(:movies, Friends.Movie, join_through: Friends.MovieActor)
  end
end
