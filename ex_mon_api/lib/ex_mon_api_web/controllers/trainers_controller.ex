defmodule ExMonApiWeb.TrainersController do
  use ExMonApiWeb, :controller

  alias ExMonApiWeb.Auth.Guardian

  action_fallback ExMonApiWeb.FallbackController

  def create(conn, params) do
    with {:ok, trainer} <- ExMonApi.create_trainer(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(trainer) do
      conn
      |> put_status(:created)
      |> render("create.json", %{trainer: trainer, token: token})
    end
  end

  def delete(conn, %{"id" => id}) do
    id
    |> ExMonApi.delete_trainer()
    |> handle_delete(conn)
  end

  def show(conn, %{"id" => id}) do
    id
    |> ExMonApi.fetch_trainer()
    |> handle_response(conn, "show.json", :ok)
  end

  def update(conn, params) do
    params
    |> ExMonApi.update_trainer()
    |> handle_response(conn, "update.json", :ok)
  end

  defp handle_delete({:ok, _trainer}, conn) do
    conn
    |> put_status(:no_content)
    |> text("")
  end

  defp handle_delete({:error, _reason} = error, _conn), do: error

  defp handle_response({:ok, trainer}, conn, view, status) do
    conn
    |> put_status(status)
    |> render(view, trainer: trainer)
  end

  defp handle_response({:error, reason}, _conn, _view, _status), do: {:error, reason}
end
