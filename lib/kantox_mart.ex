defmodule KantoxMart do
  @moduledoc """
  Handling of the cashiers actions.
  """

  alias KantoxMart.Basket
  alias KantoxMart.Cashier

  @doc """
  Creates a new cashier in the system and starts a dynamic basket worker

  ## Examples

      iex> KantoxMart.create_cashier("cashier1")
      :ok

      iex> KantoxMart.create_cashier("cashier1")
      {:error, :cashier_already_exists}

      iex> KantoxMart.create_cashier("")
      {:error, :wrong_arguments}

      iex> KantoxMart.create_cashier(%{})
      {:error, :wrong_arguments}
  """
  @spec create_cashier(name :: bitstring()) ::
          :ok | {:error, :wrong_arguments | :cashier_already_exists}
  def create_cashier(name) when is_bitstring(name) do
    validate_name(valid_name_input?(name), name)
  end

  def create_cashier(_), do: {:error, :wrong_arguments}

  @doc """
  Adds product to basket list

  ## Examples

      iex> KantoxMart.add_product_to_basket("cashier1", ["GR1"])
      :ok

  """
  @spec add_product_to_basket(cashier :: bitstring(), products_list :: list()) :: :ok
  def add_product_to_basket(cashier, products_list) do
    Basket.add(cashier, products_list)
  end

  @doc """
  Get total amount from basket

  ## Examples

      iex> KantoxMart.add_product_to_basket("cashier1" ["GR1"])
      :ok

      iex> KantoxMart.get_total_basket_amount("cashier1")

  """
  @spec get_total_basket_amount(cashier :: bitstring()) :: bitstring()
  def get_total_basket_amount(cashier) do
    [{basket_pid, _}] = Registry.lookup(KantoxMart.CashierRegistry, cashier)
    [{basket_stash_pid, _}] = Registry.lookup(KantoxMart.BasketStashRegistry, cashier)
    total = Basket.total(cashier)
    :ok = DynamicSupervisor.terminate_child(Cashier, basket_pid)
    :ok = DynamicSupervisor.terminate_child(Cashier, basket_stash_pid)
    total
  end

  @spec validate_name(boolean(), name :: bitstring()) ::
          :ok | {:error, :wrong_arguments | :cashier_already_exists}
  defp validate_name(true, name), do: Cashier.new(name)
  defp validate_name(false, _), do: {:error, :wrong_arguments}

  @spec valid_name_input?(name :: bitstring()) :: true | false
  defp valid_name_input?(name) do
    String.valid?(name) and String.length(name) > 0
  end
end
