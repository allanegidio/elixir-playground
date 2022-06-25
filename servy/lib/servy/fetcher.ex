defmodule Servy.Fetcher do
  def async(func) do
    parent = self()

    spawn(fn -> send(parent, {:result, func.()}) end)
  end

  def get_result do
    receive do
      {:result, value} ->
        value
    end
  end
end
