defmodule Servy.InvalidRouteCounter do
  @name :counter_server

  # Client functions

  def start(initial_state \\ %{}) do
    IO.puts("Starting the pledge server...")
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def bump_count(path) do
    send(@name, {self(), :bump_count, path})

    receive do
      {:response, count} -> count
    end
  end

  def get_counts() do
    send(@name, {self(), :get_counts})

    receive do
      {:response, counts} -> counts
    end
  end

  def get_count(path) do
    send(@name, {self(), :get_count, path})

    receive do
      {:response, counts} -> counts
    end
  end

  # Server functions
  def listen_loop(counter) do
    IO.puts("\nWaiting for an invalid route...")

    receive do
      {sender, :bump_count, path} ->
        new_counter = Map.update(counter, path, 1, &(&1 + 1))
        send(sender, {:response, Map.get(new_counter, path)})
        listen_loop(new_counter)

      {sender, :get_counts} ->
        send(sender, {:response, counter})
        listen_loop(counter)

      {sender, :get_count, path} ->
        send(sender, {:response, Map.get(counter, path)})
        listen_loop(counter)

      unexpected ->
        IO.puts("Unexpected messages: #{inspect(unexpected)}")
        listen_loop(counter)
    end
  end
end
