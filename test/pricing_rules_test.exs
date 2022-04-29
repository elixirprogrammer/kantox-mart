defmodule PricingRulesTest do
  use ExUnit.Case

  test "green tee offer" do
    assert [3.11] = PrincingRules.apply_offers([3.11, 3.11])

    assert [3.11, 3.11] = PrincingRules.apply_offers([3.11, 3.11, 3.11])

    assert [3.11, 3.11, 3.11] = PrincingRules.apply_offers([3.11, 3.11, 3.11, 3.11])

    assert [3.11] = PrincingRules.apply_offers([3.11])
  end

  test "strawberry offer" do
    assert [4.50, 4.50, 4.50] = PrincingRules.apply_offers([5.00, 5.00, 5.00])

    assert [4.50, 4.50, 4.50, 4.50] = PrincingRules.apply_offers([5.00, 5.00, 5.00, 5.00])

    assert [5.00, 5.00] = PrincingRules.apply_offers([5.00, 5.00])
  end

  test "coffee offer" do
    assert [7.486666666666667, 7.486666666666667, 7.486666666666667] =
             PrincingRules.apply_offers([11.23, 11.23, 11.23])

    assert [7.486666666666667, 7.486666666666667, 7.486666666666667, 7.486666666666667] =
             PrincingRules.apply_offers([11.23, 11.23, 11.23, 11.23])

    assert [11.23, 11.23] = PrincingRules.apply_offers([11.23, 11.23])
  end

  test "all offers" do
    prices = [3.11, 3.11, 5.00, 5.00, 5.00, 11.23, 11.23, 11.23]
    expected = [3.11, 4.50, 4.50, 4.50, 7.486666666666667, 7.486666666666667, 7.486666666666667]

    assert PrincingRules.apply_offers(prices) == expected
  end

  test "no offers" do
    assert [3] = PrincingRules.apply_offers([3])

    assert [3.11, 5.00, 11.23] = PrincingRules.apply_offers([3.11, 5.00, 11.23])
  end
end
