defmodule BasketTest do
  use ExUnit.Case

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

  test "updates basket list" do
    product = %Product{code: "GR1", name: "Green tea", price: 3.11}

    assert :ok = Basket.add(product)
    assert :ok = Basket.add(product)

    assert :ok = Basket.update([%Product{code: "GR1", name: "Green tea", price: 3.11}])
    assert [%Product{code: "GR1", name: "Green tea", price: 3.11}] = Basket.get()
  end
end
