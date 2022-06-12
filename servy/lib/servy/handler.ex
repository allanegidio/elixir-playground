defmodule Servy.Handler do
  alias Servy.Plugins
  alias Servy.Parser
  alias Servy.FileHandler
  # import Servy.Plugins, only: [rewrite_path: 1, track: 1]

  alias Servy.Conv

  @moduledoc "Handles HTTP requests."
  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> Parser.parse()
    |> Plugins.rewrite_path()
    |> route
    |> emojify
    |> Plugins.track()
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %Conv{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %Conv{conv | status: 200, resp_body: "Bears, Bears, Bears"}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %Conv{conv | status: 200, resp_body: "Bear #{id}"}
  end

  # @pages_path Path.expand("../../pages", __DIR__)
  @pages_path Path.expand("pages", File.cwd!())

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> FileHandler.handle_file(conv)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    %{
      conv
      | status: 201,
        resp_body: "Create a #{conv.params["type"]} bear named #{conv.params["name"]}!"
    }
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> FileHandler.handle_file(conv)
  end

  def route(%Conv{path: path} = conv) do
    %Conv{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    %Conv{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   file_path =
  #     Path.expand("../../pages/", __DIR__)
  #     |> Path.join("about.html")

  #   case File.read(file_path) do
  #     {:ok, content} -> %{conv | status: 200, resp_body: content}
  #     {:error, :enoent} -> %{conv | status: 404, resp_body: "File not found!"}
  #     {:error, reason} -> %{conv | status: 500, resp_body: "File error: #{reason}"}
  #   end
  # end

  def emojify(%Conv{status: 200} = conv) do
    emojies = String.duplicate("🎉", 5)
    body = emojies <> conv.resp_body <> emojies

    %Conv{conv | resp_body: body}
  end

  def emojify(%Conv{} = conv), do: conv

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{String.length(conv.resp_body)}

    #{conv.resp_body}
    """
  end
end

#########################################################
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

###########################################################

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

###########################################################

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

###########################################################

request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

###########################################################

request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

###########################################################

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

##########################################################

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

##########################################################

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts(response)
