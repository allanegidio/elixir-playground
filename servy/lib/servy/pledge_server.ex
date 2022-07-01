defmodule Servy.PledgeServer do
  @name :pledge_server

  # Client functions
  def start(initial_state \\ []) do
    IO.puts("Starting the pledge server...")
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def create_pledge(name, amount) do
    call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    call(@name, :recent_pledges)
  end

  def total_pledged() do
    call(@name, :total_pledged)
  end

  def call(pid, message) do
    send(pid, {self(), message})

    receive do
      {:response, response} -> response
    end
  end

  # Server functions
  def listen_loop(cache) do
    IO.puts("\nWaiting for a message...")

    receive do
      {sender, message} when is_pid(sender) ->
        {response, new_cache} = handle_call(message, cache)
        send(sender, {:response, response})
        listen_loop(new_cache)

      unexpected ->
        IO.puts("Unexpected messages: #{inspect(unexpected)}")
    end
  end

  def handle_call(:recent_pledges, cache) do
    {cache, cache}
  end

  def handle_call({:create_pledge, name, amount}, cache) do
    {:ok, id} = send_pledge_to_service(name, amount)

    most_recent_pledges = Enum.take(cache, 2)
    new_cache = [{name, amount} | most_recent_pledges]

    {id, new_cache}
  end

  def handle_call(:total_pledged, cache) do
    total =
      cache
      |> Enum.map(&elem(&1, 1))
      |> Enum.sum()

    {total, cache}
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
