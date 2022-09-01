defmodule CryptobotWeb.Services.Api.CryptoMarket.CoinGeckoTest do
  use Cryptobot.DataCase

  alias CryptobotWeb.Services.Api.CryptoMarket.CoinGecko

  describe "get_coin_data/1" do
    test "it should return the formatted history of the coin" do
      {:ok, data} = CoinGecko.get_coin_data("bitcoin")

      date =
        DateTime.utc_now()
        |> DateTime.to_date()
        |> Timex.format!("%B %e, %Y", :strftime)

      assert data == %{date => "$123.45"}
    end

    test "it should return an error when something went wrong with the api" do
      assert {:error, :coin_gecko_api_error} = CoinGecko.get_coin_data("errorMock")
    end
  end

  describe "search_coin/2" do
    test "it should return the formmated search result" do
      {:ok, %{"bitcoin" => bitcoin, "huobi-btc" => _hbtc, "wrapped-bitcoin" => _wbtc}} =
        CoinGecko.search_coin("bitcoin", 5)

      assert %{name: "Bitcoin", thumb: thumb} = bitcoin
      assert is_binary(thumb)
    end

    test "it should limit the results" do
      {:ok, data} = CoinGecko.search_coin("bitcoin", 2)
      assert Enum.count(data) == 2
    end

    test "it should return an error when something went wrong with the api" do
      assert {:error, :coin_gecko_api_error} = CoinGecko.search_coin("errorMock", 5)
    end
  end
end
