defmodule CryptobotWeb.Services.Api.CryptoMarket do
  alias CryptobotWeb.Services.Api.CryptoMarket.CoinGecko

  @valid_markets ["coin_gecko", "mock"]

  def get_coin_data(identifier, market \\ "coin_gecko") when market in @valid_markets do
    assign_market(market).get_coin_data(identifier)
  end

  # this will allow us to easily implement other 3rd party crypto market API's
  # but we need to make sure that they will implement the same behaviour
  def assign_market("coin_gecko"), do: CoinGecko
end
