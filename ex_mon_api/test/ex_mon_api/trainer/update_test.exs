defmodule ExMonApi.Trainer.UpdateTest do
  use ExMonApi.DataCase

  alias ExMonApi.Trainer.{Update, Create}

  describe "call/1" do
    test "when id is valid and trainer exists, should update trainer" do
      # Arrange
      params = %{name: "Allan", password: "123456"}
      {:ok, %{id: trainer_id_created}} = Create.call(params)

      # Act
      params = %{"id" => trainer_id_created, "name" => "Egidio", "password" => "654321"}
      {:ok, trainer_updated} = Update.call(params)

      assert %{name: "Egidio"} = trainer_updated
    end

    test "when id is valid and trainer does not exists, should return error" do
      # Arrange
      params = %{"id" => "65167064-9114-49bf-b417-7fa7ba602797"}

      # Act
      result = Update.call(params)

      # Assert
      assert {:error, %{message: "Trainer not found!", status: 404}} = result
    end

    test "when id is invalid, should return error" do
      # Arrange
      params = %{"id" => "uuid not valid"}

      # Act
      result = Update.call(params)

      # Assert
      assert {:error, %{message: "Invalid ID format!", status: 400}} = result
    end
  end
end
