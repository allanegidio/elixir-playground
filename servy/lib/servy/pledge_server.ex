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

# alias Servy.PledgeServer

# pid = PledgeServer.start()

# send(pid, {:stop, "hammertime"})

# IO.inspect(PledgeServer.create_pledge("larry", 10))
# IO.inspect(PledgeServer.create_pledge("moe", 20))
# IO.inspect(PledgeServer.create_pledge("curly", 30))
# IO.inspect(PledgeServer.create_pledge("daisy", 40))

# PledgeServer.clear()

# IO.inspect(PledgeServer.create_pledge("grace", 50))

# IO.inspect(PledgeServer.recent_pledges())

# IO.inspect(PledgeServer.total_pledged())
