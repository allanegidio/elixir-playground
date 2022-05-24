defmodule ExMonApi.Trainer.Pokemon.UpdateTest do
  use ExMonApi.DataCase

  alias ExMonApi.Trainer
  alias ExMonApi.Trainer.Pokemon
  alias ExMonApi.Trainer.Create, as: TrainerCreate
  alias ExMonApi.Trainer.Pokemon.Create, as: TrainerPokemonCreate
  alias ExMonApi.Trainer.Pokemon.Update, as: TrainerPokemonUpdate

  import Tesla.Mock

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  describe "call/1" do
    test "when id is valid and trainer exists, should return pokemon" do
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
      {:ok, %Trainer{id: trainer_id_created}} = TrainerCreate.call(params)

      params = %{"name" => "pikachu", "nickname" => "Ratao", "trainer_id" => trainer_id_created}
      {:ok, %Pokemon{id: pokemon_id_created}} = TrainerPokemonCreate.call(params)

      # Act
      params = %{"id" => pokemon_id_created, "nickname" => "Marotao"}
      {:ok, trainer} = TrainerPokemonUpdate.call(params)

      # Assert
      assert %Pokemon{
               name: "pikachu",
               nickname: "Marotao",
               weight: 60,
               types: ["eletric"],
               trainer_id: _trainer_id_created
             } = trainer
    end

    test "when params is invalid, should return error" do
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
      {:ok, %Trainer{id: trainer_id_created}} = TrainerCreate.call(params)

      params = %{"name" => "pikachu", "nickname" => "Ratao", "trainer_id" => trainer_id_created}
      {:ok, %Pokemon{id: pokemon_id_created}} = TrainerPokemonCreate.call(params)

      # Act
      params = %{"id" => pokemon_id_created, "nickname" => "M"}
      {:error, result} = TrainerPokemonUpdate.call(params)

      # Assert
      assert %{nickname: ["should be at least 2 character(s)"]} == errors_on(result)
    end

    test "when id is valid but pokemon does not exists, should return error" do
      # Arrange
      params = %{"id" => "65167064-9114-49bf-b417-7fa7ba602797"}

      # Act
      result = TrainerPokemonUpdate.call(params)

      # Assert
      assert {:error, %{message: "Pokemon not found!", status: 404}} = result
    end

    test "when id is invalid, should return error" do
      # Arrange
      params = %{"id" => "uuid not valid"}

      # Act
      result = TrainerPokemonUpdate.call(params)

      # Assert
      assert {:error, %{message: "Invalid ID format!", status: 400}} = result
    end
  end
end
