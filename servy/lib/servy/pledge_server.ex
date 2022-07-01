defmodule Servy.GenericServer do
  def start(callback_module, initial_state \\ [], name) do
    pid = spawn(callback_module, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  def listen_loop(cache, callback_module) do
    IO.puts("\nWaiting for a message...")

    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_cache} = callback_module.handle_call(message, cache)
        send(sender, {:response, response})
        listen_loop(new_cache, callback_module)

      {:cast, message} ->
        new_cache = callback_module.handle_cast(message, cache)
        listen_loop(new_cache, callback_module)

      unexpected ->
        IO.puts("Unexpected messages: #{inspect(unexpected)}")
    end
  end
end

defmodule Servy.PledgeServer do
  @name :pledge_server

  alias Servy.GenericServer

  # Client functions
  def start() do
    GenericServer.start(__MODULE__, [], @name)
  end

  def create_pledge(name, amount) do
    GenericServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenericServer.call(@name, :recent_pledges)
  end

  def total_pledged() do
    GenericServer.call(@name, :total_pledged)
  end

  def clear do
    GenericServer.cast(@name, :clear)
  end

  # Server functions

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

  def handle_cast(:clear, _cache) do
    []
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
