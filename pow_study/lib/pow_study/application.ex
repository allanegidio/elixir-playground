defmodule PowStudy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      PowStudy.Repo,
      # Start the Telemetry supervisor
      PowStudyWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PowStudy.PubSub},
      # Start the Endpoint (http/https)
      PowStudyWeb.Endpoint
      # Start a worker by calling: PowStudy.Worker.start_link(arg)
      # {PowStudy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PowStudy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PowStudyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
