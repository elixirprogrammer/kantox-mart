defmodule Inventory do
  @moduledoc """
  This module is defined to registered test products
  """

  def get_test_products() do
    [
      %Product{code: "GR1", name: "Green tea", price: 3.11},
      %Product{code: "SR1", name: "Strawberries", price: 5.00},
      %Product{code: "CR1", name: "Green tea", price: 11.23}
    ]
  end
end