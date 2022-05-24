defmodule ExMonApi.Trainer.Pokemon.CreateTest do
  use ExMonApi.DataCase

  alias ExMonApi.Trainer.Pokemon
  alias ExMonApi.Trainer.Create, as: TrainerCreate
  alias ExMonApi.Trainer.Pokemon.Create, as: TrainerPokemonCreate

  import Tesla.Mock

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  describe "call/1" do
    test "when all params are valid, created a trainer" do
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
      {:ok, %{id: trainer_id_created}} = TrainerCreate.call(params)

      # Act
      params = %{"name" => "pikachu", "nickname" => "Ratao", "trainer_id" => trainer_id_created}
      {:ok, pokemon} = TrainerPokemonCreate.call(params)

      # Assert
      assert %Pokemon{
               name: "pikachu",
               nickname: "Ratao",
               types: ["eletric"],
               weight: 60,
               trainer_id: _trainer_id_created
             } = pokemon
    end

    test "when all params are valid, but trainer does not exists, returns trainer not found" do
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
        "name" => "pikachu",
        "nickname" => "Ratao",
        "trainer_id" => "65167064-9114-49bf-b417-7fa7ba602797"
      }

      {:error, result} = TrainerPokemonCreate.call(params)

      # Assert
      assert %{message: "Trainer not found!", status: 404} = result
    end

    test "when all params are invalid, returns the error" do
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

      params = %{"name" => "pikachu", "nickname" => "o", "trainer_id" => ""}

      # Act
      {:error, reason} = TrainerPokemonCreate.call(params)

      # Assert
      assert errors_on(reason) == %{
               nickname: ["should be at least 2 character(s)"],
               trainer_id: ["can't be blank"]
             }
    end

    test "when pokemon does not exists, returns pokemon not found" do
      # Arrange
      mock(fn %{method: :get, url: @base_url <> "troll"} ->
        %Tesla.Env{status: 404}
      end)

      params = %{
        "name" => "troll",
        "nickname" => "pokelixao",
        "trainer_id" => "65167064-9114-49bf-b417-7fa7ba602797"
      }

      # Act
      {:error, reason} = TrainerPokemonCreate.call(params)

      # Assert
      assert %{message: "Pokemon not found!", status: 404} == reason
    end
  end
end
