defmodule KantoxMart.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: KantoxMart.CashierRegistry},
      {Registry, keys: :unique, name: KantoxMart.BasketStashRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: KantoxMart.Cashier},
    ]

    opts = [strategy: :one_for_one, name: KantoxMart.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
