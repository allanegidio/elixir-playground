defmodule Servy.Wildthings do
  alias Servy.Bear

  @templates_path Path.expand("db/", __DIR__)

  def list_bears do
    @templates_path
    |> Path.join("bears.json")
    |> read_file()
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn bear -> bear.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_bear()
  end

  defp read_file(path) do
    case File.read(path) do
      {:ok, contents} ->
        contents

      {:error, reason} ->
        IO.inspect("Error reading #{path}: #{reason}")
        "[]"
    end
  end
end
