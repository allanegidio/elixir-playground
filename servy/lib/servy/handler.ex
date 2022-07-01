defmodule Servy.Handler do
  alias Servy.Plugins
  # import Servy.Plugins, only: [rewrite_path: 1, track: 1]

  alias Servy.Parser
  alias Servy.FileHandler
  alias Servy.BearController
  alias Servy.Api.BearController, as: ApiBearController
  alias Servy.Conv
  alias Servy.Fetcher
  alias Servy.VideoCam
  alias Servy.Tracker
  alias Servy.View
  alias Servy.InvalidRouteCounter

  @moduledoc "Handles HTTP requests."
  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> Parser.parse()
    |> Plugins.rewrite_path()
    |> route
    |> emojify
    |> Plugins.track()
    |> put_content_length
    |> format_response
  end

  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      IO.puts("Warning: #{path} is on the loose!")
      InvalidRouteCounter.bump_count(path)
    end

    conv
  end

  def route(%Conv{method: "GET", path: "/404s"} = conv) do
    counts = Servy.InvalidRouteCounter.get_counts()

    %{conv | status: 200, resp_body: inspect(counts)}
  end

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges/new"} = conv) do
    Servy.PledgeController.new(conv)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    pid = Fetcher.async(fn -> Tracker.get_location("bigfoot") end)

    where_is_bigfoot = Fetcher.get_result(pid)

    %{conv | status: 200, resp_body: inspect(where_is_bigfoot)}
  end

  def route(%Conv{method: "GET", path: "/snapshots"} = conv) do
    task = Task.async(fn -> Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await(&1, :infinity))

    where_is_bigfoot = Task.await(task, :infinity)

    View.render(conv, "snapshots.eex", snapshots: snapshots, location: where_is_bigfoot)
  end

  @pages_path Path.expand("pages", File.cwd!())
  # @pages_path Path.expand("../../pages", __DIR__)

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer() |> :timer.sleep()

    %{conv | status: 200, resp_body: "Awake!"}
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> FileHandler.handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/kaboom"}) do
    raise "Kaboom!"
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> FileHandler.handle_file(conv)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> name} = conv) do
    @pages_path
    |> Path.join("#{name}.md")
    |> File.read()
    |> FileHandler.handle_file(conv)
    |> markdown_to_html()
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %Conv{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    ApiBearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    BearController.delete(conv)
  end

  def route(%Conv{path: path} = conv) do
    %Conv{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def route(%{method: "GET", path: "/about"} = conv) do
    file_path =
      Path.expand("../../pages/", __DIR__)
      |> Path.join("about.html")

    case File.read(file_path) do
      {:ok, content} -> %{conv | status: 200, resp_body: content}
      {:error, :enoent} -> %{conv | status: 404, resp_body: "File not found!"}
      {:error, reason} -> %{conv | status: 500, resp_body: "File error: #{reason}"}
    end
  end

  def emojify(%Conv{status: 200} = conv) do
    emojies = String.duplicate("🎉", 5)
    body = emojies <> conv.resp_body <> emojies

    %Conv{conv | resp_body: body}
  end

  def emojify(%Conv{} = conv), do: conv

  def put_content_length(%Conv{} = conv) do
    headers = Map.put(conv.resp_headers, "Content-Length", byte_size(conv.resp_body))
    %Conv{conv | resp_headers: headers}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.resp_body}
    """
  end

  defp format_response_headers(%Conv{} = conv) do
    Enum.map(conv.resp_headers, fn {key, value} -> "#{key}: #{value}\r" end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.join("\n")
  end

  defp markdown_to_html(%Conv{status: 200} = conv) do
    %{conv | resp_body: Earmark.as_html!(conv.resp_body)}
  end

  defp markdown_to_html(%Conv{} = conv), do: conv
end
