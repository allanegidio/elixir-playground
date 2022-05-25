defmodule ExMonApiWeb.Controllers.TrainerPokemonsControllerTest do
  use ExMonApiWeb.ConnCase

  alias ExMonApi.Trainer
  alias ExMonApi.Trainer.Pokemon

  import Tesla.Mock

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  describe "create/2" do
    test "when given valid params, returns the pokemon", %{conn: conn} do
      # Arrange
      body = %{
        "id" => "1",
        "name" => "pikachu",
        "weight" => 60,
        "types" => [%{"type" => %{"name" => "eletric"}}]
      }

      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: id}} = ExMonApi.create_trainer(params)

      # Act
      params = %{name: "pikachu", nickname: "rato amarelo", trainer_id: id}

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, params))
        |> json_response(:created)

      # Assert
      assert %{
               "message" => "Pokemon created!",
               "pokemon" => %{
                 "name" => "pikachu",
                 "nickname" => "rato amarelo",
                 "trainer_id" => _id,
                 "types" => ["eletric"],
                 "weight" => 60
               }
             } = response
    end

    test "when pokemon does not exists, return not found", %{conn: conn} do
      # Arrange
      mock(fn %{method: :get, url: @base_url <> "troll"} ->
        %Tesla.Env{status: 404}
      end)

      # Act
      params = %{
        name: "troll",
        nickname: "rato amarelo",
        trainer_id: "6a74ff17-8a0f-4798-b12b-0d61a1e0811c"
      }

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, params))
        |> json_response(:not_found)

      # Assert
      assert %{"message" => %{"message" => "Pokemon not found!", "status" => 404}} == response
    end

    test "when add pokemon to trainer that does not exists, return not found", %{conn: conn} do
      # Arrange
      body = %{
        "id" => "1",
        "name" => "pikachu",
        "weight" => 60,
        "types" => [%{"type" => %{"name" => "eletric"}}]
      }

      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      # Act
      params = %{
        name: "pikachu",
        nickname: "rato amarelo",
        trainer_id: "6a74ff17-8a0f-4798-b12b-0d61a1e0811c"
      }

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, params))
        |> json_response(:not_found)

      # Assert
      assert %{"message" => %{"message" => "Trainer not found!", "status" => 404}} == response
    end

    test "when there is invalid params, returns the error", %{conn: conn} do
      # Arrange
      body = %{
        "id" => "1",
        "name" => "pikachu",
        "weight" => 60,
        "types" => [%{"type" => %{"name" => "eletric"}}]
      }

      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      # Act
      params = %{name: "pikachu", nickname: "", trainer_id: ""}

      response =
        conn
        |> post(Routes.trainer_pokemons_path(conn, :create, params))
        |> json_response(:bad_request)

      # Assert
      assert %{
               "message" => %{
                 "nickname" => ["can't be blank"],
                 "trainer_id" => ["can't be blank"]
               }
             } == response
    end
  end

  describe "show/2" do
    test "when there is a pokemon with the given id, returns the pokemon", %{conn: conn} do
      # Arrange
      body = %{
        "id" => "1",
        "name" => "pikachu",
        "weight" => 60,
        "types" => [%{"type" => %{"name" => "eletric"}}]
      }

      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: trainer_id}} = ExMonApi.create_trainer(params)

      params = %{"name" => "pikachu", "nickname" => "rato amarelo", "trainer_id" => trainer_id}

      {:ok, %Pokemon{id: pokemon_id}} = ExMonApi.create_trainer_pokemon(params)

      # Act
      response =
        conn
        |> get(Routes.trainer_pokemons_path(conn, :show, pokemon_id))
        |> json_response(:ok)

      # Assert
      assert %{
               "pokemon" => %{
                 "name" => "pikachu",
                 "nickname" => "rato amarelo",
                 "trainer" => %{"id" => _trainer_id, "name" => "Allan"},
                 "types" => ["eletric"],
                 "weight" => 60
               }
             } = response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> get(Routes.trainer_pokemons_path(conn, :show, "1234"))
        |> json_response(:bad_request)

      # Assert
      assert %{"message" => %{"message" => "Invalid ID format!", "status" => 400}} == response
    end

    test "when pokemon does not exists, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> get(Routes.trainer_pokemons_path(conn, :show, "87bdaa2f-d0f2-42cc-97cb-70bca8d1de0c"))
        |> json_response(:not_found)

      # Assert
      assert %{"message" => %{"message" => "Pokemon not found!", "status" => 404}} == response
    end
  end

  describe "delete/2" do
    test "when there is a pokemon with the given id, delete the trainer", %{conn: conn} do
      # Arrange
      body = %{
        "id" => "1",
        "name" => "pikachu",
        "weight" => 60,
        "types" => [%{"type" => %{"name" => "eletric"}}]
      }

      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: trainer_id}} = ExMonApi.create_trainer(params)

      params = %{"name" => "pikachu", "nickname" => "rato amarelo", "trainer_id" => trainer_id}

      {:ok, %Pokemon{id: pokemon_id}} = ExMonApi.create_trainer_pokemon(params)

      # Act
      response =
        conn
        |> get(Routes.trainer_pokemons_path(conn, :delete, pokemon_id))
        |> json_response(:ok)

      # Assert
      assert %{
               "pokemon" => %{
                 "name" => "pikachu",
                 "nickname" => "rato amarelo",
                 "trainer" => %{"id" => _trainer_id, "name" => "Allan"},
                 "types" => ["eletric"],
                 "weight" => 60
               }
             } = response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> get(Routes.trainer_pokemons_path(conn, :delete, "1234"))
        |> json_response(:bad_request)

      # Assert
      assert %{"message" => %{"message" => "Invalid ID format!", "status" => 400}} == response
    end

    test "when pokemon does not exists, returns the error", %{conn: conn} do
      # Act
      response =
        conn
        |> get(
          Routes.trainer_pokemons_path(conn, :delete, "87bdaa2f-d0f2-42cc-97cb-70bca8d1de0c")
        )
        |> json_response(:not_found)

      # Assert
      assert %{"message" => %{"message" => "Pokemon not found!", "status" => 404}} == response
    end
  end

  describe "update/2" do
    test "when there is a trainer with the given id, update the trainer", %{conn: conn} do
      # Arrange
      body = %{
        "id" => "1",
        "name" => "pikachu",
        "weight" => 60,
        "types" => [%{"type" => %{"name" => "eletric"}}]
      }

      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: trainer_id}} = ExMonApi.create_trainer(params)

      params = %{"name" => "pikachu", "nickname" => "rato amarelo", "trainer_id" => trainer_id}

      {:ok, %Pokemon{id: pokemon_id}} = ExMonApi.create_trainer_pokemon(params)

      # Act
      params = %{nickname: "Pokemon Updated"}

      response =
        conn
        |> patch(Routes.trainer_pokemons_path(conn, :update, pokemon_id, params))
        |> json_response(:ok)

      # Assert
      assert %{
               "message" => "Pokemon updated!",
               "pokemon" => %{
                 "name" => "pikachu",
                 "nickname" => "Pokemon Updated",
                 "types" => ["eletric"],
                 "weight" => 60
               }
             } = response
    end

    test "when there is invalid params, returns the error", %{conn: conn} do
      # Arrange
      body = %{
        "id" => "1",
        "name" => "pikachu",
        "weight" => 60,
        "types" => [%{"type" => %{"name" => "eletric"}}]
      }

      mock(fn %{method: :get, url: @base_url <> "pikachu"} ->
        %Tesla.Env{status: 200, body: body}
      end)

      params = %{name: "Allan", password: "123456"}

      {:ok, %Trainer{id: trainer_id}} = ExMonApi.create_trainer(params)

      params = %{"name" => "pikachu", "nickname" => "rato amarelo", "trainer_id" => trainer_id}

      {:ok, %Pokemon{id: pokemon_id}} = ExMonApi.create_trainer_pokemon(params)

      # Act
      params = %{nickname: ""}

      response =
        conn
        |> patch(Routes.trainer_pokemons_path(conn, :update, pokemon_id, params))
        |> json_response(:bad_request)

      # Assert
      assert %{"message" => %{"nickname" => ["can't be blank"]}} == response
    end

    test "when there is an error, returns the error", %{conn: conn} do
      # Arrange
      params = %{nickname: ""}

      # Act
      response =
        conn
        |> patch(Routes.trainer_pokemons_path(conn, :update, "1234", params))
        |> json_response(:bad_request)

      # Assert
      assert %{"message" => %{"message" => "Invalid ID format!", "status" => 400}} == response
    end

    test "when pokemon does not exists, returns the error", %{conn: conn} do
      # Arrange
      id = "87bdaa2f-d0f2-42cc-97cb-70bca8d1de0c"
      params = %{nickname: ""}

      # Act
      response =
        conn
        |> patch(Routes.trainer_pokemons_path(conn, :update, id, params))
        |> json_response(:not_found)

      # Assert
      assert %{"message" => %{"message" => "Pokemon not found!", "status" => 404}} == response
    end
  end
end
