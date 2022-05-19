defmodule ExMonApiWeb.TrainerPokemonsController do
  use ExMonApiWeb, :controller

  action_fallback ExMonApiWeb.FallbackController

  def create(conn, params) do
    params
    |> ExMonApi.create_trainer_pokemon()
    |> handle_response(conn, "create.json", :created)
  end

  def delete(conn, %{"id" => id}) do
    id
    |> ExMonApi.delete_trainer_pokemon()
    |> handle_delete(conn)
  end

  defp handle_response({:ok, trainer_pokemon}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, trainer_pokemon: trainer_pokemon)
  end

  defp handle_response({:error, _changeset} = error, _conn, _view, _status), do: error

  defp handle_delete({:ok, _pokemon}, conn) do
    conn
    |> put_status(:no_content)
    |> text("")
  end

  defp handle_delete({:error, _reason} = error, _con), do: error
end
