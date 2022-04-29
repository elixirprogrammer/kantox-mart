defmodule KantoxMart do
  @moduledoc """
  Handling of the cashiers actions.
  """

  @doc """
  Adds product to basket list

  ## Examples

      iex> KantoxMart.add_to_basket(["GR1"])
      :ok

  """
  def add_to_basket(products_list) do
    Enum.each(products_list, fn product_code ->
      Basket.add(get_product_from_inventory(product_code))
    end)
  end

  @doc """
  Gets total amount from basket list

  ## Examples

      iex> KantoxMart.get_checkout_total()
      "£3.11"

  """
  def get_checkout_total() do
    total = Basket.total()
    :ok = Basket.empty()
    total
  end

  defp get_product_from_inventory(product_code) do
    Inventory.get_test_products()
    |> Enum.find(fn %{code: code} -> code == product_code end)
  end
end
