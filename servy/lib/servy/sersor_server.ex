defmodule SensorState do
  defstruct sensor_data: %{},
            refresh_interval: :timer.seconds(5)
end

defmodule Servy.SensorServer do
  @name :sensor_server

  # :timer.minutes(60)
  # @refresh_interval :timer.seconds(5)

  use GenServer

  # Client Interface
  def start() do
    GenServer.start(__MODULE__, %SensorState{}, name: @name)
  end

  def start_link(interval) do
    IO.puts("Starting the sensor server with #{interval} min refresh...")
    GenServer.start_link(__MODULE__, %SensorState{}, name: @name)
  end

  def get_sensor_data do
    GenServer.call(@name, :get_sensor_data, 10000)
  end

  def set_refresh_interval(time_in_ms) do
    GenServer.cast(@name, {:set_refresh_interval, time_in_ms})
  end

  # Server Callbacks
  def init(state) do
    sensor_data = run_tasks_to_get_sensor_data()

    initial_state = %{state | sensor_data: sensor_data}

    schedule_refresh(state.refresh_interval)

    {:ok, initial_state}
  end

  def handle_info(:refresh, state) do
    IO.puts("Refreshing the cache...")
    sensor_data = run_tasks_to_get_sensor_data()

    new_state = %{state | sensor_data: sensor_data}

    schedule_refresh(new_state.refresh_interval)

    {:noreply, new_state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state.sensor_data, state}
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts("Running tasks to get sensor data...")

    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await(&1, :infinity))

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end

  defp schedule_refresh(time_in_ms) do
    Process.send_after(self(), :refresh, time_in_ms)
  end
end
