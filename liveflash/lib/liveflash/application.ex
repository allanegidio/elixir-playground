defmodule Liveflash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      LiveflashWeb.Telemetry,
      # Start the Ecto repository
      Liveflash.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Liveflash.PubSub},
      # Start Finch
      {Finch, name: Liveflash.Finch},
      # Start the Endpoint (http/https)
      LiveflashWeb.Endpoint
      # Start a worker by calling: Liveflash.Worker.start_link(arg)
      # {Liveflash.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Liveflash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveflashWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
