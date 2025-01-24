defmodule UniElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      UniElixirWeb.Telemetry,
      UniElixir.Repo,
      {DNSCluster, query: Application.get_env(:uni_elixir, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: UniElixir.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: UniElixir.Finch},
      # Start a worker by calling: UniElixir.Worker.start_link(arg)
      # {UniElixir.Worker, arg},
      # Start to serve requests, typically the last entry
      UniElixirWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: UniElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    UniElixirWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
