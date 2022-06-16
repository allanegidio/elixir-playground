defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [header, body] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(header, "\n")

    [method, path, _] =
      request_line
      |> String.split(" ")

    headers = parse_headers(header_lines)

    params = parse_params(headers, body)

    %Conv{method: method, params: params, header: headers, path: path}
  end

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn line, headers_so_far ->
      [key, value] = String.split(line, ": ")
      Map.put(headers_so_far, key, value)
    end)
  end

  defp parse_params(%{"Content-Type" => "application/x-www-form-urlencoded"}, params_string) do
    params_string
    |> String.trim()
    |> URI.decode_query()
  end

  defp parse_params(_, _), do: %{}
end
