defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears do
    [
      %Bear{type: "Brown", name: "Teddy", id: 1, hibernating: true},
      %Bear{type: "Black", name: "Smokey", id: 2, hibernating: false},
      %Bear{type: "Brown", name: "Paddington", id: 3, hibernating: false},
      %Bear{type: "Grizzly", name: "Scarface", id: 4, hibernating: true},
      %Bear{type: "Polar", name: "Snow", id: 5, hibernating: false},
      %Bear{type: "Grizzly", name: "Brutus", id: 6, hibernating: false},
      %Bear{type: "Black", name: "Rosie", id: 7, hibernating: true},
      %Bear{type: "Panda", name: "Roscoe", id: 8, hibernating: false},
      %Bear{type: "Polar", name: "Iceman", id: 9, hibernating: true},
      %Bear{type: "Grizzly", name: "Kenai", id: 10, hibernating: false}
    ]
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn bear -> bear.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_bear()
  end
end
