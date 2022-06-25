defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer
  alias Servy.HttpClient

  describe "test" do
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
      parent = self()
      max_concurrent_requests = 5

      for _ <- 1..max_concurrent_requests do
        spawn(fn ->
          {:ok, response} = HTTPoison.get("http://localhost:5000/wildthings")

          send(parent, {:ok, response})
        end)
      end

      for _ <- 1..max_concurrent_requests do
        receive do
          {:ok, response} ->
            assert response.status_code == 200
            assert response.body == "🎉🎉🎉🎉🎉Bears, Lions, Tigers🎉🎉🎉🎉🎉"
        end
      end
    end
  end
end
