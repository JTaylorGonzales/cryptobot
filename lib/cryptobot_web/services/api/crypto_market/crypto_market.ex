defmodule CryptobotWeb.Services.Api.CryptoMarket do
  alias CryptobotWeb.Services.Api.CryptoMarket.CoinGecko

  @moduledoc """
    this module allow us to easily implement other 3rd party crypto market API's
    but we need to make sure that they will implement the same behaviour
  """

  @valid_markets [:coin_gecko]

  @spec get_coin_data(any, market :: atom()) ::
          {:error, :coin_gecko_api_error | :invalid_market | :no_crypto_found | :unexpected_error}
          | {:ok, any}
  def get_coin_data(identifier, market \\ :coin_gecko) when market in @valid_markets do
    assign_market(market).get_coin_data(identifier)
  end

  def get_coin_data(_id, _market), do: {:error, :invalid_market}

  @spec search_coin(any, limit :: integer(), market :: atom()) ::
          {:error, :coin_gecko_api_error | :invalid_market | :no_crypto_found | :unexpected_error}
          | {:ok, any}
  def search_coin(name, limit \\ 5, market \\ :coin_gecko) when market in @valid_markets do
    assign_market(market).search_coin(name, limit)
  end

  def search_coin(_name, _limit, _market), do: {:error, :invalid_market}

  defp assign_market(:coin_gecko), do: CoinGecko
end
