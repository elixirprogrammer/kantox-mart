defmodule KantoxMart.Basket do
  @moduledoc """
  Defined for basket handling.
  """

  use GenServer

  alias Number.Currency
  alias KantoxMart.PricingRules
  alias KantoxMart.Cashier
  alias KantoxMart.Inventory
  alias KantoxMart.BasketStash

  @spec start_link(options :: tuple()) ::
          {:ok, pid()} | :ignore | {:error, {:already_started, pid()} | term()}
  def start_link(options) do
    {:ok, {:via, Registry, {KantoxMart.CashierRegistry, cashier}}} = Keyword.fetch(options, :name)
    GenServer.start_link(__MODULE__, cashier, options)
  end
  @spec add(cashier :: bitstring(), products_list :: list()) :: :ok
  def add(cashier, products_list) do
    Enum.each(products_list, fn product_code ->
      product = get_product_from_inventory(product_code)
      GenServer.cast(Cashier.via_tuple(cashier), {:add, product})
    end)
  end

  @spec total(cashier :: bitstring()) :: bitstring()
  def total(cashier) do
    GenServer.call(Cashier.via_tuple(cashier), :total)
  end

  @impl true
  def init(cashier) do
    {:ok, {cashier, BasketStash.get_saved_basket(cashier)}}
  end

  @impl true
  def handle_call(:total, _from, {cashier, basket}) do
    total = get_total(basket)
    BasketStash.save_basket(cashier, [])
    {:reply, total, {cashier, []}}
  end

  @impl true
  def handle_cast({:add, product}, {cashier, basket}) do
    {:noreply, {cashier, [product | basket]}}
  end

  @impl true
  def terminate(_reason, {cashier, basket}) do
    BasketStash.save_basket(cashier, basket)
  end

  @spec get_total(basket :: list()) :: bitstring()
  defp get_total(basket) do
    basket
    |> PricingRules.apply_offers()
    |> Enum.map(fn %{price: price} -> price end)
    |> Enum.sum()
    |> Currency.number_to_currency(unit: "£")
  end

  @spec get_product_from_inventory(prouct_code :: bitstring()) :: struct()
  defp get_product_from_inventory(product_code) do
    Inventory.get_test_products()
    |> Enum.find(fn %{code: code} -> code == product_code end)
  end
end
