defmodule ExMonApiWeb.FallbackController do
  use ExMonApiWeb, :controller

  def call(conn, {:error, %{message: _message, status: 400} = result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ExMonApiWeb.ErrorView)
    |> render("400.json", result: result)
  end

  def call(conn, {:error, %Ecto.Changeset{valid?: false} = result}) do
    conn
    |> put_status(:bad_request)
    |> put_view(ExMonApiWeb.ErrorView)
    |> render("400.json", result: result)
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ExMonApiWeb.ErrorView)
    |> render("403.json", %{message: "Unauthorized"})
  end

  def call(conn, {:error, %{message: _message, status: 404} = result}) do
    conn
    |> put_status(:not_found)
    |> put_view(ExMonApiWeb.ErrorView)
    |> render("404.json", result: result)
  end
end
