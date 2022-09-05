defmodule CryptobotWeb.Services.Api.CryptoMarket do
  alias CryptobotWeb.Services.Api.CryptoMarket.CoinGecko

  @moduledoc """
    this module allow us to easily implement other 3rd party crypto market API's,
    by just assign the wanted API as a parameter. but we need to make sure that they will implement the same behaviour
  """

  @valid_markets [:coin_gecko]

  def get_coin_data(identifier, market \\ :coin_gecko) when market in @valid_markets do
    assign_market(market).get_coin_data(identifier)
  end

  def search_coin(name, limit \\ 5, market \\ :coin_gecko) when market in @valid_markets do
    assign_market(market).search_coin(name, limit)
  end

  defp assign_market(:coin_gecko), do: CoinGecko
end
