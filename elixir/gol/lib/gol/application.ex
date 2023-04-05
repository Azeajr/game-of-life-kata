defmodule Gol.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GolWeb.Telemetry,
      # Start the Ecto repository
      Gol.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Gol.PubSub},
      # Start Finch
      {Finch, name: Gol.Finch},
      # Start the Endpoint (http/https)
      GolWeb.Endpoint
      # Start a worker by calling: Gol.Worker.start_link(arg)
      # {Gol.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gol.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GolWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
