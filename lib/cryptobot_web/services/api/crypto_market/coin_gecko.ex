defmodule CryptobotWeb.Services.Api.CryptoMarket.CoinGecko do
  # by setting the api module on the config, we can easily mock our API for testing purposes

  @coin_gecko_api Application.get_env(:cryptobot, :coin_gecko)[:coin_gecko_api]

  def get_coin_data(identifier) do
    case @coin_gecko_api.get(
           "/coins/#{identifier}/market_chart?vs_currency=usd&days=13&interval=daily"
         ) do
      {:ok, %{body: %{"prices" => prices}}} ->
        parse_data(prices)

      {:error, _error} ->
        {:error, :coin_gecko_api_error}

      _ ->
        {:error, :unexpected_error}
    end
  end

  defp parse_data(prices) do
    data =
      Enum.reduce(prices, %{}, fn [date, price], acc ->
        parsed_date =
          date
          |> DateTime.from_unix!(:millisecond)
          |> DateTime.to_date()
          |> Timex.format!("%B %e, %Y", :strftime)

        Map.put(acc, parsed_date, "$#{Float.round(price, 2)}")
      end)

    {:ok, data}
  end
end
