defmodule Triv.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Triv.GameServer.registry_spec(),
      %{id: Triv.GameServer, start: {Triv.GameServer, :start_link, []}, type: :worker},
      TrivWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Triv.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TrivWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
