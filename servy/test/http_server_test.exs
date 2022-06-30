defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer
  alias Servy.HttpClient

  describe "Testing HTTP Server" do
    setup do
      spawn(HttpServer, :start, [5000])

      :ok
    end

    test "accepts a request on a socket and sends back a response" do
      request = """
      GET /wildthings HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """

      response = HttpClient.send_request(request)

      assert response == """
             HTTP/1.1 200 OK\r
             Content-Type: text/html\r
             Content-Length: 30\r
             \r
             🎉🎉🎉🎉🎉Bears, Lions, Tigers🎉🎉🎉🎉🎉
             """
    end

    test "accepts a request on a socket and sends back a response using HTTPoison" do
      {:ok, response} = HTTPoison.get("http://localhost:5000/wildthings")

      assert response.status_code == 200
      assert response.body == "🎉🎉🎉🎉🎉Bears, Lions, Tigers🎉🎉🎉🎉🎉"
    end

    test "accepts a 5 concurrent requests on a socket and sends back a response using HTTPoison " do
      max_concurrent_requests = 5

      1..max_concurrent_requests
      |> Enum.map(fn _ ->
        Task.async(fn -> HTTPoison.get("http://localhost:5000/wildthings") end)
      end)
      |> Enum.map(&Task.await/1)
      |> Enum.map(&assert_successful_response/1)
    end

    defp assert_successful_response({:ok, response}) do
      assert response.status_code == 200
      assert response.body == "🎉🎉🎉🎉🎉Bears, Lions, Tigers🎉🎉🎉🎉🎉"
    end

    test "test a lot of URL" do
      urls = [
        "http://localhost:5000/wildthings",
        "http://localhost:5000/bears",
        "http://localhost:5000/bears/1",
        "http://localhost:5000/wildlife",
        "http://localhost:5000/api/bears"
      ]

      urls
      |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end))
      |> Enum.map(&Task.await/1)
      |> Enum.map(&assert_ok_response/1)
    end

    defp assert_successful_response({:ok, response}) do
      assert response.status_code == 200
      assert response.body == "🎉🎉🎉🎉🎉Bears, Lions, Tigers🎉🎉🎉🎉🎉"
    end

    defp assert_ok_response({:ok, response}) do
      assert response.status_code == 200
    end
  end
end
