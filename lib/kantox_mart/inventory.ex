defmodule KantoxMart.Inventory do
  @moduledoc """
  This module is defined to register test products
  """

  alias KantoxMart.Product

  def get_test_products() do
    [
      %Product{code: "GR1", name: "Green tea", price: 3.11},
      %Product{code: "SR1", name: "Strawberries", price: 5.00},
      %Product{code: "CF1", name: "Coffee", price: 11.23}
    ]
  end
end
