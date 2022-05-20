defmodule ExMonApi.TrainerPokemonTest do
  use ExMonApi.DataCase

  alias ExMonApi.Trainer.Pokemon

  describe "changeset/1" do
    test "when all params are valid, returns a valid changeset" do
      params = %{
        name: "Pikachu",
        nickname: "Borracha",
        weight: 60,
        types: ["Eletric"],
        trainer_id: "d2b3704e-cf42-4e29-8301-15cc091e6034"
      }

      result = Pokemon.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                 name: "Pikachu",
                 nickname: "Borracha",
                 trainer_id: "d2b3704e-cf42-4e29-8301-15cc091e6034",
                 types: ["Eletric"],
                 weight: 60
               },
               data: %ExMonApi.Trainer.Pokemon{},
               valid?: true
             } = result
    end

    test "when there are invalid params, return an invalid changeset" do
      params = %{
        name: "Pikachu",
        nickname: "Borracha",
        types: [:eletric],
        trainer_id: "d2b3704e-cf42-4e29-8301-15cc091e6034"
      }

      result = Pokemon.changeset(params)

      assert %Ecto.Changeset{
               changes: %{
                 name: "Pikachu",
                 nickname: "Borracha",
                 trainer_id: "d2b3704e-cf42-4e29-8301-15cc091e6034"
               },
               errors: [
                 weight: {"can't be blank", [validation: :required]},
                 types: {"is invalid", [type: {:array, :string}, validation: :cast]}
               ],
               data: %ExMonApi.Trainer.Pokemon{},
               valid?: false
             } = result

      assert errors_on(result) == %{types: ["is invalid"], weight: ["can't be blank"]}
    end
  end

  describe "update_changeset/1" do
    test "when all params are valid, returns a valid updated changeset" do
      pokemon = %Pokemon{
        name: "pikachu",
        nickname: "rato amarelo",
        types: ["eletric"],
        weight: 60,
        trainer_id: "290dfe0e-50cf-4016-af9b-d533512a10d8"
      }

      params = %{
        nickname: "gabiru"
      }

      result = Pokemon.update_changeset(pokemon, params)

      assert %Ecto.Changeset{
               changes: %{nickname: "gabiru"},
               errors: [],
               data: %ExMonApi.Trainer.Pokemon{},
               valid?: true
             } = result
    end

    test "when there are invalid params, return an invalid updated changeset" do
      pokemon = %Pokemon{
        name: "pikachu",
        nickname: "rato amarelo",
        types: ["eletric"],
        weight: 60,
        trainer_id: "290dfe0e-50cf-4016-af9b-d533512a10d8"
      }

      params = %{
        nickname: "g"
      }

      result = Pokemon.update_changeset(pokemon, params)

      assert %Ecto.Changeset{
               changes: %{nickname: "g"},
               errors: [
                 nickname:
                   {"should be at least %{count} character(s)",
                    [count: 2, validation: :length, kind: :min, type: :string]}
               ],
               data: %ExMonApi.Trainer.Pokemon{},
               valid?: false
             } = result

      assert errors_on(result) == %{nickname: ["should be at least 2 character(s)"]}
    end
  end
end
