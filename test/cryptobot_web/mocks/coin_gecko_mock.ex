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
end
