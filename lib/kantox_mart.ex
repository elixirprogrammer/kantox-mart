defmodule KantoxMart do
  @moduledoc """
  Documentation for `KantoxMart`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> KantoxMart.hello()
      :world

  """
  def add_to_basket(products_list) do
    Enum.each(products_list, fn product_code ->
      Basket.add(get_product_from_inventory(product_code))
    end)
  end

  def get_checkout_total() do
    Basket.total()
  end

  defp get_product_from_inventory(product_code) do
    Inventory.get_test_products()
    |> Enum.find(fn %{code: code} -> code == product_code end)
  end
end
