defmodule ExMonApiWeb.TrainersController do
  use ExMonApiWeb, :controller

  def create(conn, trainer) do
    trainer
    |> ExMonApi.create_trainer()
    |> handle_response(conn)
  end

  defp handle_response({:ok, trainer}, conn) do
    conn
    |> put_status(:created)
    |> render("create.json", trainer: trainer)
  end
end
