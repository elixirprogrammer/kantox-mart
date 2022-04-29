defmodule PrincingRules do
  @moduledoc """
  Defined to apply pricing rules
  """

  def apply_offers(price_amounts_list) do
    price_amounts_list
    |> special_condition(:green_tea)
    |> special_condition(:strawberry)
    |> special_condition(:coffee)
  end

  defp special_condition(price_amounts_list, :green_tea) do
    green_tea_quantity = Enum.count(price_amounts_list, &(&1 == 3.11))

    green_tea_offer(green_tea_quantity, price_amounts_list)
  end

  defp special_condition(price_amounts_list, :strawberry) do
    strawberry_quantity = Enum.count(price_amounts_list, &(&1 == 5.00))

    strawberry_offer(strawberry_quantity, price_amounts_list)
  end

  defp special_condition(price_amounts_list, :coffee) do
    coffee_quantity = Enum.count(price_amounts_list, &(&1 == 11.23))

    coffee_offer(coffee_quantity, price_amounts_list)
  end

  defp green_tea_offer(green_tea_quantity, price_amounts_list) when green_tea_quantity > 1 do
    List.delete(price_amounts_list, 3.11)
  end

  defp green_tea_offer(_green_tea_quantity, price_amounts_list) do
    price_amounts_list
  end

  defp strawberry_offer(green_tea_quantity, price_amounts_list) when green_tea_quantity >= 3 do
    price_amounts_list
    |> Enum.map(& drop_strawberry_price(&1))
  end

  defp strawberry_offer(_green_tea_quantity, price_amounts_list) do
    price_amounts_list
  end

  defp coffee_offer(green_tea_quantity, price_amounts_list) when green_tea_quantity >= 3 do
    price_amounts_list
    |> Enum.map(& drop_coffee_price(&1))
  end

  defp coffee_offer(_green_tea_quantity, price_amounts_list) do
    price_amounts_list
  end

  defp drop_strawberry_price(price) when price == 5.00, do: 4.50
  defp drop_strawberry_price(price), do: price

  defp drop_coffee_price(price) when price == 11.23, do: 11.23 / 3 * 2
  defp drop_coffee_price(price), do: price
end
