defmodule PrincingRules do
  @moduledoc """
  Defined to apply pricing rules
  """

  def apply_offers(price_amounts_list) do
    price_amounts_list
    |> special_condition(:green_tea)
  end

  defp special_condition(price_amounts_list, :green_tea) do
    green_tea_quantity = Enum.count(price_amounts_list, &(&1 == 3.11))

    green_tea_offer(green_tea_quantity, price_amounts_list)
  end

  defp green_tea_offer(green_tea_quantity, price_amounts_list) when green_tea_quantity > 1 do
    List.delete(price_amounts_list, 3.11)
  end

  defp green_tea_offer(_green_tea_quantity, price_amounts_list) do
    price_amounts_list
  end
end
