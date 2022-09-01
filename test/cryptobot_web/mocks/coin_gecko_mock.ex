defmodule Cryptobot.Mocks.CoinGeckoMock do
  def get("/coins/bitcoin/market_chart?vs_currency=usd&days=13&interval=daily") do
    {:ok,
     %{
       body: %{
         "prices" => [
           [DateTime.utc_now() |> DateTime.to_unix(:millisecond), 123.446]
         ]
       }
     }}
  end

  def get("/coins/errorMock/market_chart?vs_currency=usd&days=13&interval=daily") do
    {:error, :coin_gecko_api_error}
  end

  def get("/search?query=bitcoin") do
    {:ok,
     %{
       body: %{
         "coins" => [
           %{
             "api_symbol" => "bitcoin",
             "id" => "bitcoin",
             "large" => "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
             "market_cap_rank" => 1,
             "name" => "Bitcoin",
             "symbol" => "BTC",
             "thumb" => "https://assets.coingecko.com/coins/images/1/thumb/bitcoin.png"
           },
           %{
             "api_symbol" => "wrapped-bitcoin",
             "id" => "wrapped-bitcoin",
             "large" =>
               "https://assets.coingecko.com/coins/images/7598/large/wrapped_bitcoin_wbtc.png",
             "market_cap_rank" => 19,
             "name" => "Wrapped Bitcoin",
             "symbol" => "WBTC",
             "thumb" =>
               "https://assets.coingecko.com/coins/images/7598/thumb/wrapped_bitcoin_wbtc.png"
           },
           %{
             "api_symbol" => "huobi-btc",
             "id" => "huobi-btc",
             "large" => "https://assets.coingecko.com/coins/images/12407/large/Unknown-5.png",
             "market_cap_rank" => 60,
             "name" => "Huobi BTC",
             "symbol" => "HBTC",
             "thumb" => "https://assets.coingecko.com/coins/images/12407/thumb/Unknown-5.png"
           }
         ]
       }
     }}
  end

  def get("/search?query=errorMock") do
    {:error, :coin_gecko_api_error}
  end
end
