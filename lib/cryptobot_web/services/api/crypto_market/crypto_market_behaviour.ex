defmodule CryptobotWeb.Services.Api.CryptoMarket.CryptoMarketBehaviour do
  @callback get_coin_data(id :: String.t()) ::
              {:error,
               :coin_gecko_api_error | :invalid_market | :no_crypto_found | :unexpected_error}
              | {:ok, coin_data :: map()}
  @callback search_coin(name :: String.t(), limit :: integer()) ::
              {:error,
               :coin_gecko_api_error | :invalid_market | :no_crypto_found | :unexpected_error}
              | {:ok, coin_data :: map()}
end
