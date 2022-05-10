defmodule PrincingRules do
  @moduledoc """
  Defined to apply pricing rules
  """

  @offers [:green_tea, :strawberry, :coffee]

  @doc """
  Applies defined offers for each product inside basket list, then updates the basket list state
  when offers applied and price updated, and returns the basket.

  ## Examples

      iex> PrincingRules.apply_offers()
      [%Product{code: "GR1", name: "Green tea", price: 3.11}]

      iex> PrincingRules.apply_offers()
      [
        %Product{code: "SR1", name: "Strawberries", price: 4.50},
        %Product{code: "SR1", name: "Strawberries", price: 4.50},
        %Product{code: "SR1", name: "Strawberries", price: 4.50}
      ]

      iex> PrincingRules.apply_offers([11.23, 11.23, 11.23])
      [
        %Product{code: "CF1", name: "Coffee", price: 7.486666666666667},
        %Product{code: "CF1", name: "Coffee", price: 7.486666666666667},
        %Product{code: "CF1", name: "Coffee", price: 7.486666666666667}
      ]


  """
  @spec apply_offers() :: list()
  def apply_offers() do
    @offers |> Enum.each(&special_condition(&1))

    Basket.get()
  end

  # Removes a green tea product from basket list if more than one is bought
  defp special_condition(:green_tea) do
    basket_list = Basket.get()
    green_tea_quantity = Enum.count(basket_list, &(&1.price == 3.11))

    if green_tea_quantity > 1, do: green_tea_offer(basket_list)
  end

  # Drops strawberry price to 4.50 for each product in basket list if 3 or more bought
  defp special_condition(:strawberry) do
    basket_list = Basket.get()
    strawberry_quantity = Enum.count(basket_list, &(&1.price == 5.00))

    if strawberry_quantity >= 3, do: strawberry_offer(basket_list)
  end

  # Drops coffee price to two thirds for each product in basket list if 3 or more bought
  defp special_condition(:coffee) do
    basket_list = Basket.get()
    coffee_quantity = Enum.count(basket_list, &(&1.price == 11.23))

    if coffee_quantity >= 3, do: coffee_offer(basket_list)
  end

  defp green_tea_offer(basket_list) do
    basket_list
    |> List.delete(%Product{code: "GR1", name: "Green tea", price: 3.11})
    |> Basket.update()
  end

  defp strawberry_offer(basket_list) do
    basket_list
    |> Enum.map(&drop_strawberry_price(&1))
    |> Basket.update()
  end

  defp coffee_offer(basket_list) do
    basket_list
    |> Enum.map(&drop_coffee_price(&1))
    |> Basket.update()
  end

  defp drop_strawberry_price(product) when product.price == 5.00, do: %{product | price: 4.50}
  defp drop_strawberry_price(product), do: product

  defp drop_coffee_price(product) when product.price == 11.23, do: %{product | price: 11.23 / 3 * 2}
  defp drop_coffee_price(product), do: product
end
