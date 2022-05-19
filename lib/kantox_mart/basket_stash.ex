defmodule KantoxMart.BasketStash do
  @moduledoc """
  Defined to back basket state when terminated
  """

  use GenServer

  @spec start_link(options :: tuple()) ::
          {:ok, pid()} | :ignore | {:error, {:already_started, pid()} | term()}
  def start_link(options), do: GenServer.start_link(__MODULE__, [], options)

  @spec save_basket(cashier :: bitstring(), basket :: list()) :: :ok
  def save_basket(cashier, basket_state) do
    GenServer.cast({:via, Registry, {KantoxMart.BasketStashRegistry, cashier}}, {:save_basket, basket_state})
  end

  @spec get_saved_basket(cashier :: bitstring()) :: list()
  def get_saved_basket(cashier) do
    GenServer.call({:via, Registry, {KantoxMart.BasketStashRegistry, cashier}}, :get_saved_basket)
  end

  @impl true
  def init(basket) do
    {:ok, basket}
  end

  @impl true
  def handle_cast({:save_basket, basket_state}, _basket) do
    {:noreply, basket_state}
  end

  @impl true
  def handle_call(:get_saved_basket, _from, basket) do
    {:reply, basket, basket}
  end
end
