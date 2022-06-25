defmodule Servy.Fetcher do
  alias Servy.VideoCam

  def async(camera_name) do
    parent = self()

    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot(camera_name)}) end)
  end

  def get_result do
    receive do
      {:result, filename} ->
        filename
    end
  end
end
