defmodule Mafia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    if Mix.env() in [:dev, :test] do
      children = [
        # Start the Ecto repository
        Mafia.Repo,
        # Start the Telemetry supervisor
        MafiaWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: Mafia.PubSub},
        # Start the Endpoint (http/https)
        MafiaWeb.Endpoint,

        #      {Redix, "redis://localhost:6379"}
        {Redix, {"redis://localhost:6379", [name: RedisConnection]}},
        #      { Redix, {"redis://:#{System.fetch_env!("REDIS_PASSWORD")}@#{System.fetch_env!("REDIS_HOST")}:#{redis_port}", [name: RedisConnection]} },
        Mafia.Presence,
        # Start a worker by calling: Mafia.Worker.start_link(arg)
        # {Mafia.Worker, arg}
      ]
      # See https://hexdocs.pm/elixir/Supervisor.html
      # for other strategies and supported options
      opts = [strategy: :one_for_one, name: Mafia.Supervisor]
      Supervisor.start_link(children, opts)
    else
      redis_port = Mafia.Utility.parsInt(System.fetch_env!("REDIS_PORT"))
      children = [
        # Start the Ecto repository
        Mafia.Repo,
        # Start the Telemetry supervisor
        MafiaWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: Mafia.PubSub},
        # Start the Endpoint (http/https)
        MafiaWeb.Endpoint,

        #      {Redix, "redis://localhost:6379"}
#        {Redix, {"redis://localhost:6379", [name: RedisConnection]}},
        { Redix, {"redis://:#{System.fetch_env!("REDIS_PASSWORD")}@#{System.fetch_env!("REDIS_HOST")}:#{redis_port}", [name: RedisConnection]},},

        Mafia.Presence,
        # Start a worker by calling: Mafia.Worker.start_link(arg)
        # {Mafia.Worker, arg}
      ]
      # See https://hexdocs.pm/elixir/Supervisor.html
      # for other strategies and supported options
      opts = [strategy: :one_for_one, name: Mafia.Supervisor]
      Supervisor.start_link(children, opts)
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MafiaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
