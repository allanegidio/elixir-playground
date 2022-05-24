defmodule ExMonApi.Trainer.DeleteTest do
  use ExMonApi.DataCase

  alias ExMonApi.{Repo, Trainer}
  alias Trainer.{Create, Delete}

  describe "call/1" do
    test "when id is valid and trainer exists, should delete" do
      # Arrange
      params = %{name: "Allan", password: "123456"}
      {:ok, %{id: trainer_id_created}} = Create.call(params)
      count_before = Repo.aggregate(Trainer, :count)

      # Act
      {:ok, trainer_deleted} = Delete.call(trainer_id_created)
      count_after = Repo.aggregate(Trainer, :count)

      # Assert
      assert %Trainer{name: "Allan", id: _trainer_id_created} = trainer_deleted
      assert count_before > count_after
    end

    test "when id is valid and trainer does not exists, should return error" do
      # Arrange
      params = "65167064-9114-49bf-b417-7fa7ba602797"

      # Act
      result = Delete.call(params)

      # Assert
      assert {:error, %{message: "Trainer not found!", status: 404}} = result
    end

    test "when id is invalid, should return error" do
      # Arrange
      params = "uuid not valid"

      # Act
      result = Delete.call(params)

      # Assert
      assert {:error, %{message: "Invalid ID format!", status: 400}} = result
    end
  end
end
