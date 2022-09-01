defmodule CryptobotWeb.Services.Api.CryptoMarket.CoinGecko do
  # by setting the api module on the config, we can easily mock our API for testing purposes

  @coin_gecko_api Application.get_env(:cryptobot, :coin_gecko)[:coin_gecko_api]

  def get_coin_data(id) do
    case @coin_gecko_api.get("/coins/#{id}/market_chart?vs_currency=usd&days=13&interval=daily") do
      {:ok, %{body: %{"prices" => prices}}} ->
        format_coin_prices_data(prices)

      {:error, _error} ->
        {:error, :coin_gecko_api_error}

      _ ->
        {:error, :unexpected_error}
    end
  end

  def search_coin(name, limit) do
    case @coin_gecko_api.get("/search?query=#{name}") do
      {:ok, %{body: %{"coins" => coins}}} ->
        format_coins_data(coins, limit)

      {:error, _error} ->
        {:error, :coin_gecko_api_error}

      _ ->
        {:error, :unexpected_error}
    end
  end

  defp format_coins_data([], _limit), do: {:error, :no_crypto_found}

  defp format_coins_data(coins, limit) do
    data =
      coins
      |> Enum.take(limit)
      |> Enum.reduce(%{}, fn coin, acc ->
        Map.put(acc, coin["id"], %{name: coin["name"], thumb: coin["thumb"]})
      end)

    {:ok, data}
  end

  defp format_coin_prices_data(prices) do
    data =
      Enum.reduce(prices, %{}, fn [date, price], acc ->
        formatted_date =
          date
          |> DateTime.from_unix!(:millisecond)
          |> DateTime.to_date()
          |> Timex.format!("%B %e, %Y", :strftime)

        Map.put(acc, formatted_date, "$#{Float.round(price, 2)}")
      end)

    {:ok, data}
  end
end
