defmodule KantoxMartTest do
  use ExUnit.Case
  doctest KantoxMart

  test "checks out with one product" do
    KantoxMart.add_to_basket(["GR1"])
    assert "£3.11" = KantoxMart.get_checkout_total()
  end

  test "checks out with tea offer" do
    KantoxMart.add_to_basket(["GR1", "GR1"])
    assert "£3.11" = KantoxMart.get_checkout_total()
  end

  test "checks out with strawberry offer" do
    KantoxMart.add_to_basket(["SR1", "SR1", "GR1", "SR1"])
    assert "£16.61" = KantoxMart.get_checkout_total()
  end

  test "checks out with cofee offer" do
    KantoxMart.add_to_basket(["GR1", "CF1", "SR1", "CF1", "CF1"])
    assert "£30.57" = KantoxMart.get_checkout_total()
  end

  test "checks out with available offers" do
    KantoxMart.add_to_basket(["GR1", "SR1", "GR1", "GR1", "CF1"])
    assert "£22.45" = KantoxMart.get_checkout_total()
  end
end
