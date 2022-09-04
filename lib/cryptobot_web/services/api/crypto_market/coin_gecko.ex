defmodule CryptobotWeb.Services.Api.CryptoMarket.CoinGecko do
  @behaviour CryptobotWeb.Services.Api.CryptoMarket.CryptoMarketBehaviour
  # by setting the api module on the config, we can easily mock our API for testing purposes
  @coin_gecko_api Application.get_env(:cryptobot, :coin_gecko)[:coin_gecko_api]

  @impl true
  def get_coin_data(id) do
    case @coin_gecko_api.get("/coins/#{id}/market_chart?vs_currency=usd&days=14&interval=daily") do
      {:ok, %{body: %{"prices" => prices}}} ->
        format_coin_prices_data(prices)

      {:ok, %{status_code: 404}} ->
        {:error, :no_crypto_found}

      {:error, _error} ->
        {:error, :coin_gecko_api_error}

      _ ->
        {:error, :unexpected_error}
    end
  end

  @impl true
  def search_coin(name, limit) do
    case @coin_gecko_api.get("/search?query=#{name}") do
      {:ok, %{status_code: 200, body: %{"coins" => coins}}} ->
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
        Map.put(acc, coin["market_cap_rank"], %{
          name: coin["name"],
          thumb: coin["large"],
          id: coin["id"]
        })
      end)

    {:ok, data}
  end

  defp format_coin_prices_data(prices) do
    data =
      Enum.reduce(prices, %{}, fn [date, price], acc ->
        formatted_date =
          date
          |> DateTime.from_unix!(:millisecond)
          |> Timex.format!("%B %e", :strftime)

        Map.put(acc, formatted_date, "$#{Float.round(price, 2)}")
      end)

    {:ok, data}
  end
end
