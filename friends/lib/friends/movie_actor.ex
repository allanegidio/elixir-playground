defmodule Friends.MovieActor do
  use Ecto.Schema

  schema "movies_actors" do
    field(:movie_id, :integer, primary_key: true)
    field(:actor_id, :integer, primary_key: true)
    field(:special, :boolean)
  end
end
