defmodule ExMonApi.Trainer.GetTest do
  use ExMonApi.DataCase

  alias ExMonApi.{Repo, Trainer}
  alias Trainer.{Create, Get}

  describe "call/1" do
    test "when id is valid and trainer exists, should return trainer" do
      # Arrange
      params = %{name: "Allan", password: "123456"}
      {:ok, %{id: trainer_id_created}} = Create.call(params)

      # Act
      {:ok, trainer} = Get.call(trainer_id_created)

      # Assert
      assert %Trainer{name: "Allan", id: trainer_id_created} = trainer
    end

    test "when id is valid and trainer does not exists, should return error" do
      # Arrange
      params = "65167064-9114-49bf-b417-7fa7ba602797"

      # Act
      result = Get.call(params)

      # Assert
      assert {:error, %{message: "Trainer not found!", status: 404}} = result
    end

    test "when id is invalid, should return error" do
      # Arrange
      params = "uuid not valid"

      # Act
      result = Get.call(params)

      # Assert
      assert {:error, %{message: "Invalid ID format!", status: 400}} = result
    end
  end
end
