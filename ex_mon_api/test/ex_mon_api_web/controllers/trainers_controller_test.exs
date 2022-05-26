defmodule ExMonApiWeb.Controllers.TrainersControllerTest do
  use ExMonApiWeb.ConnCase

  import ExMonApiWeb.Auth.Guardian

  alias ExMonApi.Trainer

  describe "create/2" do
    test "when given valid params, returns the trainer", %{conn: conn} do
      # Arrange
      params = %{name: "Allan", password: "123456"}

      # Act
      response =
        conn
        |> post(Routes.trainers_path(conn, :create, params))
        |> json_response(:created)

      # Assert
      assert %{
               "message" => "Trainer created!",
               "trainer" => %{
                 "name" => "Allan"
               }
             } = response
    end

    test "when there is invalid params, returns the error", %{conn: conn} do
      # Arrange
      params = %{name: "", password: ""}

      # Act
      response =
        conn
        |> post(Routes.trainers_path(conn, :create, params))
        |> json_response(:bad_request)

      # Assert
      assert %{
               "message" => %{
                 "name" => ["can't be blank"],
                 "password" => ["can't be blank"]
               }
             } == response
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      params = %{name: "Allan", password: "123456"}
      {:ok, trainer} = ExMonApi.create_trainer(params)
      {:ok, token, _claims} = encode_and_sign(trainer)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "when there is a trainer with the given id, returns the trainer", %{conn: conn} do
      # Arrange
      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(params)

      # Act
      response =
        conn
        |> get(Routes.trainers_path(conn, :show, id))
        |> json_response(:ok)

      # Assert
      assert %{
               "id" => _id,
               "inserted_at" => _inserted_at,
               "updated_at" => _update_at,
               "name" => "Allan"
             } = response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> get(Routes.trainers_path(conn, :show, "1234"))
        |> json_response(:bad_request)

      # Assert
      assert %{"message" => %{"message" => "Invalid ID format!", "status" => 400}} == response
    end

    test "when trainer does not exists, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> get(Routes.trainers_path(conn, :show, "87bdaa2f-d0f2-42cc-97cb-70bca8d1de0c"))
        |> json_response(:not_found)

      # Assert
      assert %{"message" => %{"message" => "Trainer not found!", "status" => 404}} == response
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      params = %{name: "Allan", password: "123456"}
      {:ok, trainer} = ExMonApi.create_trainer(params)
      {:ok, token, _claims} = encode_and_sign(trainer)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "when there is a trainer with the given id, delete the trainer", %{conn: conn} do
      # Arrange
      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(params)

      # Act
      response =
        conn
        |> get(Routes.trainers_path(conn, :delete, id))
        |> json_response(:ok)

      # Assert
      assert %{"name" => "Allan"} = response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> get(Routes.trainers_path(conn, :delete, "1234"))
        |> json_response(:bad_request)

      # Assert
      assert %{"message" => %{"message" => "Invalid ID format!", "status" => 400}} == response
    end

    test "when trainer does not exists, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> get(Routes.trainers_path(conn, :delete, "87bdaa2f-d0f2-42cc-97cb-70bca8d1de0c"))
        |> json_response(:not_found)

      # Assert
      assert %{"message" => %{"message" => "Trainer not found!", "status" => 404}} == response
    end
  end

  describe "update/2" do
    setup %{conn: conn} do
      params = %{name: "Allan", password: "123456"}
      {:ok, trainer} = ExMonApi.create_trainer(params)
      {:ok, token, _claims} = encode_and_sign(trainer)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "when there is a trainer with the given id, update the trainer", %{conn: conn} do
      # Arrange
      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(params)

      # Act
      params = %{name: "Trainer Updated", password: "654321"}

      response =
        conn
        |> patch(Routes.trainers_path(conn, :update, id, params))
        |> json_response(:ok)

      # Assert
      assert %{
               "message" => "Trainer updated!",
               "trainer" => %{
                 "name" => "Trainer Updated"
               }
             } = response
    end

    test "when there is invalid params, returns the error", %{conn: conn} do
      # Arrange
      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(params)

      # Act
      params = %{name: "", password: ""}

      response =
        conn
        |> patch(Routes.trainers_path(conn, :update, id, params))
        |> json_response(:bad_request)

      # Assert
      assert %{
               "message" => %{
                 "name" => ["can't be blank"],
                 "password" => ["can't be blank"]
               }
             } == response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> patch(Routes.trainers_path(conn, :update, "1234"))
        |> json_response(:bad_request)

      # Assert
      assert %{"message" => %{"message" => "Invalid ID format!", "status" => 400}} == response
    end

    test "when trainer does not exists, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> patch(Routes.trainers_path(conn, :update, "87bdaa2f-d0f2-42cc-97cb-70bca8d1de0c"))
        |> json_response(:not_found)

      # Assert
      assert %{"message" => %{"message" => "Trainer not found!", "status" => 404}} == response
    end
  end
end
