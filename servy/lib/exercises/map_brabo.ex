defmodule MapBrabo do
  def main() do
    style = %{"width" => 10, "height" => 20, "border" => "2px"}

    result = for {key, val} <- style, into: %{}, do: {String.to_atom(key), val}

    IO.inspect(result)
  end
end

# MapBrabo.main()
