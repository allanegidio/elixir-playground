defmodule Servy.PledgeServer do
  @name :pledge_server

  def start do
    IO.puts("Starting the pledge server...")
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, :pledge_server)
    pid
  end

  def listen_loop(cache) do
    IO.puts("\nWaiting for a message...")

    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(cache, 2)

        new_cache = [{name, amount} | most_recent_pledges]

        send(sender, {:response, id})
        listen_loop(new_cache)

      {sender, :recent_pledges} ->
        send(sender, {:response, cache})
        listen_loop(cache)
    end
  end

  def create_pledge(name, amount) do
    send(@name, {self(), :create_pledge, name, amount})

    receive do
      {:response, id} -> "pledge-#{id} was created!\n" |> IO.inspect()
    end
  end

  def recent_pledges() do
    send(@name, {self(), :recent_pledges})

    receive do
      {:response, pledges} -> pledges
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServer

# pid = PledgeServer.start()

# PledgeServer.create_plage("larry", 10)
# PledgeServer.create_plage("moe", 20)
# PledgeServer.create_plage("curly", 30)
# PledgeServer.create_plage("daisy", 40)
# PledgeServer.create_plage("grace", 50)

# IO.inspect(PledgeServer.recent_pledges())
