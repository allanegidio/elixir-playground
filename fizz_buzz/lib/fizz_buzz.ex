defmodule FizzBuzz do
  def build(file_name) do
    # case File.read(file_name) do
    #   { :ok, content } -> content
    #   { :error, reason } -> reason
    # end

    file_name
      |> File.read()
      |> handle_file_read()
  end

  def handle_file_read({ :ok, result }), do: result
  def handle_file_read({ :error, reason }), do: reason
end
