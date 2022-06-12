defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [header, body] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(header, "\n")

    [method, path, _] =
      request_line
      |> String.split(" ")

    headers = parse_headers(header_lines, %{})

    params = parse_params(headers["Content-Type"], body)

    %Conv{method: method, params: params, header: headers, path: path}
  end

  defp parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")
    headers = Map.put(headers, key, value)
    parse_headers(tail, headers)
  end

  defp parse_headers([], headers), do: headers

  defp parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim()
    |> URI.decode_query()
  end

  defp parse_params(_, _), do: %{}
end
