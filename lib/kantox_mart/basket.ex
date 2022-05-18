defmodule KantoxMart.Basket do
  @moduledoc """
  Defined for basket handling.
  """
  alias Number.Currency
  alias KantoxMart.PricingRules

  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  def add(product) do
    Agent.update(__MODULE__, fn products -> [product | products] end)
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end

  def empty() do
    Agent.update(__MODULE__, fn _products -> [] end)
  end

  def total() do
    get()
    |> PricingRules.apply_offers()
    |> Enum.map(fn %{price: price} -> price end)
    |> Enum.sum()
    |> Currency.number_to_currency(unit: "£")
  end
end
