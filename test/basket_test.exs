defmodule BasketTest do
  use ExUnit.Case

  alias KantoxMart.Basket
  alias KantoxMart.Product

  setup do
    assert {:ok, _pid} = Basket.start_link

    :ok
  end

  test "gets basket list" do
    assert [] = Basket.get()
  end

  test "adds product to basket list" do
    product = %Product{code: "GR1", name: "Green tea", price: 3.11}

    assert :ok = Basket.add(product)
    assert [%Product{code: "GR1", name: "Green tea", price: 3.11}] = Basket.get()
  end
end
