defmodule GOL.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GOLWeb.Telemetry,
      # Start the Ecto repository
      GOL.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: GOL.PubSub},
      # Start Finch
      {Finch, name: GOL.Finch},
      # Start the Endpoint (http/https)
      GOLWeb.Endpoint
      # Start a worker by calling: GOL.Worker.start_link(arg)
      # {GOL.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GOL.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GOLWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
