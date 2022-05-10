defmodule PrincingRules do
  @moduledoc """
  Defined to apply pricing rules
  """

  @offers [:green_tea, :strawberries, :coffee]

  # Products Prices
  @green_tea_price 3.11
  @strawberries_price 5.0
  @coffee_price 11.23

  # Products Dicount Prices
  @strawberries_price_discount 4.50
  @coffee_price_discount @coffee_price / 3 * 2

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
    green_tea_quantity = Enum.count(basket_list, &(&1.price == @green_tea_price))

    if green_tea_quantity > 1, do: green_tea_offer(basket_list)
  end

  # Drops strawberry price to 4.50 for each product in basket list if 3 or more bought
  defp special_condition(:strawberries) do
    basket_list = Basket.get()
    strawberries_quantity = Enum.count(basket_list, &(&1.price == @strawberries_price))

    if strawberries_quantity >= 3, do: strawberries_offer(basket_list)
  end

  # Drops coffee price to two thirds for each product in basket list if 3 or more bought
  defp special_condition(:coffee) do
    basket_list = Basket.get()
    coffee_quantity = Enum.count(basket_list, &(&1.price == @coffee_price))

    if coffee_quantity >= 3, do: coffee_offer(basket_list)
  end

  defp green_tea_offer(basket_list) do
    basket_list
    |> List.delete(%Product{code: "GR1", name: "Green tea", price: @green_tea_price})
    |> Basket.update()
  end

  defp strawberries_offer(basket_list) do
    basket_list
    |> Enum.map(&drop_strawberries_price(&1))
    |> Basket.update()
  end

  defp coffee_offer(basket_list) do
    basket_list
    |> Enum.map(&drop_coffee_price(&1))
    |> Basket.update()
  end

  defp drop_strawberries_price(product) when product.price == @strawberries_price do
    %{product | price: @strawberries_price_discount}
  end
  defp drop_strawberries_price(product), do: product

  defp drop_coffee_price(product) when product.price == @coffee_price do
    %{product | price: @coffee_price_discount}
  end
  defp drop_coffee_price(product), do: product
end
