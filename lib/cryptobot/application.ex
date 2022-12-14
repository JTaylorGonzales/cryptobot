defmodule Cryptobot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Cryptobot.Repo,
      # Start the Telemetry supervisor
      CryptobotWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Cryptobot.PubSub},
      # Start the Endpoint (http/https)
      CryptobotWeb.Endpoint,
      # Start a worker by calling: Cryptobot.Worker.start_link(arg)
      # {Cryptobot.Worker, arg}
      {Task.Supervisor, name: EventHandlerSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cryptobot.Supervisor]
    :ets.new(:user_input_cache, [:set, :public, :named_table])
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CryptobotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
