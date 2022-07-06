defmodule Servy.GenericServer do
  def start(callback_module, initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
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
        new_cache = callback_module.handle_info(unexpected, cache)
        listen_loop(new_cache, callback_module)
    end
  end
end
