defmodule ExMon.PokeApi.ClientTest do
  use ExUnit.Case

  import Tesla.Mock

  alias ExMonApi.PokeApi.Client

  @base_url "https://pokeapi.co/api/v2/pokemon/"

  describe "get_pokemon/1" do
    test "when there is a pokemon with the given name, returns the pokemon" do
      body = %{"name" => "pikachu", "weight" => 60, "types" => ["Eletric"]}

      mock(fn
        %{method: :get, url: @base_url <> "pikachu"} ->
          %Tesla.Env{status: 200, body: body}
      end)

      response = Client.get_pokemon("pikachu")

      expected_resposne = {:ok, body}

      assert response == expected_resposne
    end

    test "when there is no pokemon with the given name, returns pokemon not found " do
      mock(fn
        %{method: :get, url: @base_url <> "troll"} ->
          %Tesla.Env{status: 404}
      end)

      response = Client.get_pokemon("troll")

      assert response == {:error, "Pokemon not found!"}
    end

    test "when there is an unexpected error, returns the error " do
      mock(fn
        %{method: :get, url: @base_url <> "pikachu"} ->
          {:error, :timeout}
      end)

      response = Client.get_pokemon("pikachu")

      assert response == {:error, :timeout}
    end
  end
end
