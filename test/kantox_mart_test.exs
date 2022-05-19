defmodule KantoxMartTest do
  use ExUnit.Case

  @cashier1 "cashier1"

  setup do
    Application.stop(:kantox_mart)
    :ok = Application.start(:kantox_mart)
    :ok = KantoxMart.create_cashier(@cashier1)
  end

  describe "creates cashier" do
    test "error response when cashier already exists" do
      assert {:error, :cashier_already_exists} = KantoxMart.create_cashier(@cashier1)
    end

    test "error response when not a string" do
      assert {:error, :wrong_arguments} = KantoxMart.create_cashier([])
      assert {:error, :wrong_arguments} = KantoxMart.create_cashier(%{})
    end

    test "error response when empty string" do
      assert {:error, :wrong_arguments} = KantoxMart.create_cashier("")
    end
  end

  describe "checkout no special conditions" do
    test "checks out with one product" do
      assert :ok = KantoxMart.add_product_to_basket(@cashier1, ["GR1"])

      assert "£3.11" = KantoxMart.get_total_basket_amount(@cashier1)
    end

    test "checks out for each product" do
      assert :ok = KantoxMart.add_product_to_basket(@cashier1, ["GR1", "SR1", "CF1"])

      assert "£19.34" = KantoxMart.get_total_basket_amount(@cashier1)
    end
  end

  describe "checkout with special conditions" do
    test "checks out with tea offer" do
      assert :ok = KantoxMart.add_product_to_basket(@cashier1, ["GR1", "GR1"])

      assert "£3.11" = KantoxMart.get_total_basket_amount(@cashier1)
    end

    test "checks out with strawberries offer" do
      assert :ok = KantoxMart.add_product_to_basket(@cashier1, ["SR1", "SR1", "GR1", "SR1"])

      assert "£16.61" = KantoxMart.get_total_basket_amount(@cashier1)
    end

    test "checks out with cofee offer" do
      assert :ok = KantoxMart.add_product_to_basket(@cashier1, ["GR1", "CF1", "SR1", "CF1", "CF1"])

      assert "£30.57" = KantoxMart.get_total_basket_amount(@cashier1)
    end

    test "checks out with available offers" do
      assert :ok = KantoxMart.add_product_to_basket(@cashier1, ["GR1", "SR1", "GR1", "GR1", "CF1"])

      assert "£22.45" = KantoxMart.get_total_basket_amount(@cashier1)
    end
  end
end
