defmodule Servy.InvalidRouteCounter do
  @name :counter_server

  alias Servy.GenericServer

  # Client functions
  def start(initial_state \\ %{}) do
    IO.puts("Starting the invalid route server...")
    GenericServer.start(__MODULE__, initial_state, @name)
  end

  def bump_count(path) do
    GenericServer.call(@name, {:bump_count, path})
  end

  def get_counts() do
    GenericServer.call(@name, :get_counts)
  end

  def get_count(path) do
    GenericServer.call(@name, {:get_count, path})
  end

  def clear do
    GenericServer.cast(@name, :clear)
  end

  # Server callbacks
  def handle_call({:bump_count, path}, counter) do
    new_counter = Map.update(counter, path, 1, &(&1 + 1))

    {new_counter, new_counter}
  end

  def handle_call(:get_counts, counter) do
    {counter, counter}
  end

  def handle_call({:get_count, path}, counter) do
    {Map.get(counter, path), counter}
  end

  def handle_cast(:clear, _cache) do
    %{}
  end
end
