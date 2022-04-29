defmodule PrincingRules do
  @moduledoc """
  Defined to apply pricing rules
  """

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
    prices_list
    |> special_condition(:green_tea)
    |> special_condition(:strawberry)
    |> special_condition(:coffee)
  end

  # Removes a green tea price if more than one is bought
  defp special_condition(prices_list, :green_tea) do
    green_tea_quantity = Enum.count(prices_list, &(&1 == 3.11))

    green_tea_offer(green_tea_quantity, prices_list)
  end

  # Drops strawberry price to 4.50 if 3 or more bought
  defp special_condition(prices_list, :strawberry) do
    strawberry_quantity = Enum.count(prices_list, &(&1 == 5.00))

    strawberry_offer(strawberry_quantity, prices_list)
  end

  # Drops coffee price to two thirds if 3 or more bought
  defp special_condition(prices_list, :coffee) do
    coffee_quantity = Enum.count(prices_list, &(&1 == 11.23))

    coffee_offer(coffee_quantity, prices_list)
  end

  defp green_tea_offer(green_tea_quantity, prices_list) when green_tea_quantity > 1 do
    List.delete(prices_list, 3.11)
  end

  defp green_tea_offer(_green_tea_quantity, prices_list) do
    prices_list
  end

  defp strawberry_offer(green_tea_quantity, prices_list) when green_tea_quantity >= 3 do
    prices_list
    |> Enum.map(& drop_strawberry_price(&1))
  end

  defp strawberry_offer(_green_tea_quantity, prices_list) do
    prices_list
  end

  defp coffee_offer(green_tea_quantity, prices_list) when green_tea_quantity >= 3 do
    prices_list
    |> Enum.map(& drop_coffee_price(&1))
  end

  defp coffee_offer(_green_tea_quantity, prices_list) do
    prices_list
  end

  defp drop_strawberry_price(price) when price == 5.00, do: 4.50
  defp drop_strawberry_price(price), do: price

  defp drop_coffee_price(price) when price == 11.23, do: 11.23 / 3 * 2
  defp drop_coffee_price(price), do: price
end
