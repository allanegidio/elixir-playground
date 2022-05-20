defmodule ExMonApi.Trainer.CreateTest do
  use ExMonApi.DataCase

  alias ExMonApi.{Repo, Trainer}
  alias Trainer.Create

  describe "call/1" do
    test "when all params are valid, created a trainer" do
      params = %{name: "Allan", password: "123456"}

      count_before = Repo.aggregate(Trainer, :count)

      response = Create.call(params)

      count_after = Repo.aggregate(Trainer, :count)

      assert {:ok, %Trainer{name: "Allan"}} = response
      assert count_after > count_before
    end

    test "when all params are invalid, returns the error" do
      params = %{name: "Allan"}

      response = Create.call(params)

      assert {:error, changeset} = response
      assert errors_on(changeset) == %{password: ["can't be blank"]}
    end
  end
end
