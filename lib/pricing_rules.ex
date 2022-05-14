defmodule PrincingRules do
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

  @doc """
  Applies defined offers based on prices list.

  ## Examples

      iex> PrincingRules.apply_offers([3.11, 3.11])
      [3.11]

      iex> PrincingRules.apply_offers([5.00, 5.00, 5.00])
      [4.50, 4.50, 4.50]

      iex> PrincingRules.apply_offers([11.23, 11.23, 11.23])
      [7.486666666666667, 7.486666666666667, 7.486666666666667]

  """
  @spec apply_offers(prices_list :: list()) :: list()
  def apply_offers(prices_list) do
    prices_list = special_condition(:green_tea, prices_list)
    prices_list = special_condition(:strawberries, prices_list)
    special_condition(:coffee, prices_list)
  end

  # Removes a green tea price if more than one is bought
  defp special_condition(:green_tea, prices_list) do
    green_tea_quantity = Enum.count(prices_list, &(&1 == @green_tea_price))

    green_tea_offer(green_tea_quantity, prices_list)
  end

  # Drops strawberries price to 4.50 if 3 or more bought
  defp special_condition(:strawberries, prices_list) do
    strawberries_quantity = Enum.count(prices_list, &(&1 == @strawberries_price))

    strawberries_offer(strawberries_quantity, prices_list)
  end

  # Drops coffee price to two thirds if 3 or more bought
  defp special_condition(:coffee, prices_list) do
    coffee_quantity = Enum.count(prices_list, &(&1 == @coffee_price))

    coffee_offer(coffee_quantity, prices_list)
  end

  defp green_tea_offer(green_tea_quantity, prices_list) when green_tea_quantity > 1 do
    List.delete(prices_list, @green_tea_price)
  end

  defp green_tea_offer(_green_tea_quantity, prices_list) do
    prices_list
  end

  defp strawberries_offer(strawberries_quantity, prices_list) when strawberries_quantity >= 3 do
    prices_list
    |> Enum.map(&drop_strawberries_price(&1))
  end

  defp strawberries_offer(_strawberries_quantity, prices_list) do
    prices_list
  end

  defp coffee_offer(coffee_quantity, prices_list) when coffee_quantity >= 3 do
    prices_list
    |> Enum.map(&drop_coffee_price(&1))
  end

  defp coffee_offer(_coffee_quantity, prices_list) do
    prices_list
  end

  defp drop_strawberries_price(price) when price == @strawberries_price do
    @strawberries_price_discount
  end
  defp drop_strawberries_price(price), do: price

  defp drop_coffee_price(price) when price == @coffee_price, do: @coffee_price_discount
  defp drop_coffee_price(price), do: price
end
