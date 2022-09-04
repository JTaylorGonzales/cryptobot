defmodule CryptobotWeb.Services.Api.CryptoMarket.CryptoMarketBehaviour do
  @callback get_coin_data(any) ::
              {:error,
               :coin_gecko_api_error | :invalid_market | :no_crypto_found | :unexpected_error}
              | {:ok, any}
  @callback search_coin(any, limit :: integer()) ::
              {:error,
               :coin_gecko_api_error | :invalid_market | :no_crypto_found | :unexpected_error}
              | {:ok, any}
end
