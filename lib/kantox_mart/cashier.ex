defmodule KantoxMart.Cashier do
  @moduledoc """
  Functions for cashier to interact with basket
  """

  alias KantoxMart.Basket
  alias KantoxMart.BasketStash

  @spec new(name :: bitstring()) :: :ok | {:error, :cashier_already_exists}
  def new(name) do
    get_cashier_worker = Registry.lookup(KantoxMart.CashierRegistry, name)
    start_child?(cashier_worker_exists?(get_cashier_worker), name)
  end

  @spec via_tuple(name :: bitstring()) :: tuple()
  def via_tuple(name) do
    {:via, Registry, {KantoxMart.CashierRegistry, name}}
  end

  defp start_child?(true, _name), do: {:error, :cashier_already_exists}
  defp start_child?(false, name), do: start_cashier_worker(start_child(name))

  @spec cashier_worker_exists?(list()) :: boolean()
  defp cashier_worker_exists?([{_pid, _}]), do: true
  defp cashier_worker_exists?([]), do: false

  defp start_cashier_worker({:ok, _pid}), do: :ok
  defp start_cashier_worker(error), do: error

  @spec start_child(name :: bitstring()) :: :ok | {:error, any()}
  defp start_child(name) do
    via_tuple = {Basket, name: via_tuple(name)}
    via_tuple_stash = {BasketStash, name: {:via, Registry, {KantoxMart.BasketStashRegistry, name}}}
    DynamicSupervisor.start_child(__MODULE__, via_tuple_stash)
    DynamicSupervisor.start_child(__MODULE__, via_tuple) |> IO.inspect
  end
end
