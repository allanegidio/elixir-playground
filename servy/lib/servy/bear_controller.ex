defmodule BearController do
  alias Servy.{Conv, Wildthings, Bear}

  def index(conv) do
    result =
      Wildthings.list_bears()
      |> Enum.filter(fn bear -> Bear.is_grizzly(bear) end)
      |> Enum.sort(fn b1, b2 -> Bear.order_asc_by_name(b1, b2) end)
      |> Enum.map(fn bear -> bear_item(bear) end)
      |> Enum.join()

    %Conv{conv | status: 200, resp_body: "<ul>#{result}</ul>"}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %Conv{conv | status: 200, resp_body: "<h1> Bear #{bear.id}: #{bear.name} </"}
  end

  def create(conv, %{"type" => type, "name" => name}) do
    %{
      conv
      | status: 201,
        resp_body: "Create a #{type} bear named #{name}!"
    }
  end

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end
end
