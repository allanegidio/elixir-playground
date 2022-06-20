defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Conv
  alias Servy.Parser

  describe "parser/1" do
    test "parse a list of header and body fields into a map" do
      request = """
      POST /bears HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      Content-Type: application/x-www-form-urlencoded\r
      Content-Length: 21\r
      \r
      name=Baloo&type=Brown
      """

      headers = Parser.parse(request)

      assert headers == %Conv{
               header: %{
                 "Accept" => "*/*",
                 "Content-Length" => "21",
                 "Content-Type" => "application/x-www-form-urlencoded",
                 "Host" => "example.com",
                 "User-Agent" => "ExampleBrowser/1.0"
               },
               method: "POST",
               params: %{"name" => "Baloo", "type" => "Brown"},
               path: "/bears",
               resp_body: "",
               status: nil
             }
    end
  end
end
