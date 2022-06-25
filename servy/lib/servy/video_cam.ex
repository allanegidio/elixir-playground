defmodule Servy.VideoCam do
  def get_snapshot(camera_name) do
    time = :rand.uniform(10_000)
    :timer.sleep(time)

    "#{camera_name}-snapshot.jpg"
  end
end
