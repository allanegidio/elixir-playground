defmodule Mix.Tasks.Demo do
  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Mix.shell().info("Task Demo!")
  end
end
