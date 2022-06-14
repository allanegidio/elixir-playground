defmodule BearController do
  alias Servy.{Conv, Wildthings, Bear}

  def index(conv) do
    result =
      Wildthings.list_bears()
      |> Enum.filter(&Bear.is_grizzly/1)
      |> Enum.sort(&Bear.order_asc_by_name/2)
      |> Enum.map(&bear_item/1)
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
