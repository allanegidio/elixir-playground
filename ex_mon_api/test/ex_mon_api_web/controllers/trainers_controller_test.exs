defmodule ExMonApiWeb.Controllers.TrainersControllerTest do
  use ExMonApiWeb.ConnCase

  alias ExMonApi.Trainer

  describe "show/2" do
    test "when there is a trainer with the given id, returns the trainer", %{conn: conn} do
      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(params)

      response =
        conn
        |> get(Routes.trainers_path(conn, :show, id))
        |> json_response(:ok)

      assert %{
               "id" => _id,
               "inserted_at" => _inserted_at,
               "updated_at" => _update_at,
               "name" => "Allan"
             } = response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      response =
        conn
        |> get(Routes.trainers_path(conn, :show, "1234"))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid ID format!"} == response
    end
  end
end
