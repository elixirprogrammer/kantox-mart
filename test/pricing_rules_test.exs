defmodule PricingRulesTest do
  use ExUnit.Case

  setup do
    products = %{
      green_tea: %Product{code: "GR1", name: "Green tea", price: 3.11},
      strawberries: %Product{code: "SR1", name: "Strawberries", price: 5.00},
      strawberries_discount: %Product{code: "SR1", name: "Strawberries", price: 4.50},
      coffee: %Product{code: "CF1", name: "Coffee", price: 11.23},
      coffee_discount: %Product{code: "CF1", name: "Coffee", price: 7.486666666666667}
    }

    %{products: products}
  end

  describe "green tee offer" do
    test "applies offer with 2 green tee products in the basket", %{products: products} do
      basket = [
        products.green_tea,
        products.green_tea
      ]
      expected_basket = [products.green_tea]

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end

    test "applies offer with 3 green tee products in the basket", %{products: products} do
      basket = [
        products.green_tea,
        products.green_tea,
        products.green_tea
      ]
      expected_basket = [
        products.green_tea,
        products.green_tea
      ]

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end

    test "applies offer with 4 green tee products in the basket", %{products: products} do
      basket = [
        products.green_tea,
        products.green_tea,
        products.green_tea,
        products.green_tea
      ]
      expected_basket = [
        products.green_tea,
        products.green_tea,
        products.green_tea
      ]

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end

    test "applies offer with 1 green tee product in the basket", %{products: products} do
      basket = [products.green_tea]
      expected_basket = basket

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end
  end

  describe "strawberries offer" do
    test "applies offer with 3 strawberries in the basket", %{products: products} do
      basket = [
        products.strawberries,
        products.strawberries,
        products.strawberries
      ]
      expected_basket = [
        products.strawberries_discount,
        products.strawberries_discount,
        products.strawberries_discount
      ]

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end

    test "applies offer with 4 strawberries in the basket", %{products: products} do
      basket = [
        products.strawberries,
        products.strawberries,
        products.strawberries,
        products.strawberries
      ]
      expected_basket = [
        products.strawberries_discount,
        products.strawberries_discount,
        products.strawberries_discount,
        products.strawberries_discount
      ]

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end

    test "doesn't apply offer with 2 strawberries in the basket", %{products: products} do
      basket = [
        products.strawberries,
        products.strawberries
      ]
      expected_basket = basket

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end
  end

  describe "coffee offer" do
    test "applies offer with 3 coffee in the basket", %{products: products} do
      basket = [
        products.coffee,
        products.coffee,
        products.coffee
      ]
      expected_basket = [
        products.coffee_discount,
        products.coffee_discount,
        products.coffee_discount
      ]

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end

    test "applies offer with 4 coffee in the basket", %{products: products} do
      basket = [
        products.coffee,
        products.coffee,
        products.coffee,
        products.coffee
      ]
      expected_basket = [
        products.coffee_discount,
        products.coffee_discount,
        products.coffee_discount,
        products.coffee_discount
      ]

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end

    test "doesn't apply offer with 2 coffee in the basket", %{products: products} do
      basket = [
        products.coffee,
        products.coffee
      ]
      expected_basket = basket

      assert ^expected_basket = PricingRules.apply_offers(basket)
    end
  end

  test "all offers", %{products: products} do
    basket = [
      products.green_tea,
      products.green_tea,
      products.strawberries,
      products.strawberries,
      products.strawberries,
      products.coffee,
      products.coffee,
      products.coffee

    ]

    expected_basket = [
      products.green_tea,
      products.strawberries_discount,
      products.strawberries_discount,
      products.strawberries_discount,
      products.coffee_discount,
      products.coffee_discount,
      products.coffee_discount

    ]

    assert ^expected_basket = PricingRules.apply_offers(basket)
  end

  test "no offers", %{products: products} do
    basket = [
      products.green_tea,
      products.strawberries,
      products.coffee
    ]

    expected_basket = basket

    assert ^expected_basket = PricingRules.apply_offers(basket)
  end
end
