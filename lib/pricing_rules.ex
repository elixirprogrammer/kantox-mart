defmodule PricingRules do
  @moduledoc """
  Defined to apply pricing rules
  """

  # Products Prices
  @green_tea_price 3.11
  @strawberries_price 5.0
  @coffee_price 11.23

  # Products Dicount Prices
  @strawberries_price_discount 4.50
  @coffee_price_discount @coffee_price / 3 * 2

  @offers [:green_tea, :strawberries, :coffee]

  @doc """
  Applies defined offers to prices of products.

  ## Examples
      iex> products = [
        %Product{code: "GR1", name: "Green tea", price: 3.11},
        %Product{code: "GR1", name: "Green tea", price: 3.11}
      ]
      iex> PrincingRules.apply_offers(products)
      [%Product{code: "GR1", name: "Green tea", price: 3.11}]

      iex> products = [
        %Product{code: "SR1", name: "Strawberries", price: 5.00},
        %Product{code: "SR1", name: "Strawberries", price: 5.00},
        %Product{code: "SR1", name: "Strawberries", price: 5.00}
      ]
      iex> PrincingRules.apply_offers(products)
      [
        %Product{code: "SR1", name: "Strawberries", price: 4.50},
        %Product{code: "SR1", name: "Strawberries", price: 4.50},
        %Product{code: "SR1", name: "Strawberries", price: 4.50}
      ]

      iex> products = [
        %Product{code: "CF1", name: "Coffee", price: 11.23},
        %Product{code: "CF1", name: "Coffee", price: 11.23},
        %Product{code: "CF1", name: "Coffee", price: 11.23}
      ]
      iex> PrincingRules.apply_offers(products)
      [
        %Product{code: "CF1", name: "Coffee", price: 7.486666666666667},
        %Product{code: "CF1", name: "Coffee", price: 7.486666666666667},
        %Product{code: "CF1", name: "Coffee", price: 7.486666666666667}
      ]

  """
  @spec apply_offers(products :: list()) :: list()
  def apply_offers(products) do
    @offers
    |> Enum.reduce(products, fn offer, result ->
      special_condition(offer, result)
    end)
  end

  # Removes a green tea product if more than one is bought
  defp special_condition(:green_tea, products) do
    green_tea_quantity =
      Enum.count(products, fn product ->
        product.price == @green_tea_price
      end)

    green_tea_offer(green_tea_quantity, products)
  end

  # Drops strawberries price to 4.50 if 3 or more bought
  defp special_condition(:strawberries, products) do
    strawberries_quantity =
      Enum.count(products, fn product ->
        product.price == @strawberries_price
      end)

    strawberries_offer(strawberries_quantity, products)
  end

  # Drops coffee price to two thirds if 3 or more bought
  defp special_condition(:coffee, products) do
    coffee_quantity =
      Enum.count(products, fn product ->
        product.price == @coffee_price
      end)

    coffee_offer(coffee_quantity, products)
  end

  defp green_tea_offer(green_tea_quantity, products) when green_tea_quantity > 1 do
    List.delete(products, %Product{code: "GR1", name: "Green tea", price: @green_tea_price})
  end

  defp green_tea_offer(_green_tea_quantity, products), do: products

  defp strawberries_offer(strawberries_quantity, products) when strawberries_quantity >= 3 do
    products
    |> Enum.map(&drop_strawberries_price(&1))
  end

  defp strawberries_offer(_strawberries_quantity, products), do: products

  defp coffee_offer(coffee_quantity, products) when coffee_quantity >= 3 do
    products
    |> Enum.map(&drop_coffee_price(&1))
  end

  defp coffee_offer(_coffee_quantity, products), do: products

  defp drop_strawberries_price(product) when product.price == @strawberries_price do
    %{product | price: @strawberries_price_discount}
  end

  defp drop_strawberries_price(product), do: product

  defp drop_coffee_price(product) when product.price == @coffee_price do
    %{product | price: @coffee_price_discount}
  end

  defp drop_coffee_price(product), do: product
end
