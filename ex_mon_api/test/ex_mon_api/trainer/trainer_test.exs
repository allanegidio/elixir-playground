defmodule ExMonApi.TrainerTest do
  use ExMonApi.DataCase

  alias ExMonApi.Trainer

  describe "changeset/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{name: "Allan Egidio", password: "123456"}

      result = Trainer.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                 name: "Allan Egidio",
                 password: "123456"
               },
               data: %ExMonApi.Trainer{},
               valid?: true
             } = result
    end

    test "when there are invalid params, return an invalid changeset" do
      params = %{name: "Allan Egidio"}

      result = Trainer.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                 name: "Allan Egidio"
               },
               data: %ExMonApi.Trainer{},
               valid?: false
             } = result

      assert errors_on(result) == %{password: ["can't be blank"]}
    end
  end

  describe "build/1" do
    test "when all params are valid, returns a trainer struct" do
      params = %{name: "Allan Egidio", password: "123456"}

      result = Trainer.build(params)

      assert {:ok, %Trainer{name: "Allan Egidio", password: "123456"}} = result
    end

    test "when all params are invalid, returns error" do
      params = %{name: "Allan Egidio"}

      {:error, result} = Trainer.build(params)

      assert %Ecto.Changeset{valid?: false} = result
      assert errors_on(result) == %{password: ["can't be blank"]}
    end
  end
end
