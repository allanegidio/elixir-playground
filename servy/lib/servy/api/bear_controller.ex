defmodule Servy.Api.BearController do
  alias Servy.{Conv, Wildthings}

  def index(conv) do
    json =
      Wildthings.list_bears()
      |> Poison.encode!()

    conv = put_resp_content_type(conv, "application/json")

    %Conv{
      conv
      | status: 200,
        resp_body: json
    }
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end

  defp put_resp_content_type(%Conv{} = conv, type) do
    headers = Map.put(conv.resp_headers, "Content-Type", type)
    %{conv | resp_headers: headers}
  end
end
