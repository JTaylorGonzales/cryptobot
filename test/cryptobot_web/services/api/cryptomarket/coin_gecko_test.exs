defmodule CryptobotWeb.Services.Api.CryptoMarket.CoinGeckoTest do
  use Cryptobot.DataCase

  alias CryptobotWeb.Services.Api.CryptoMarket.CoinGecko

  describe "get_coin_data/1" do
    test "it should return the formatted history of the coin" do
      {:ok, data} = CoinGecko.get_coin_data("bitcoin")

      date =
        DateTime.utc_now()
        |> DateTime.to_date()
        |> Timex.format!("%B %e", :strftime)

      assert data == %{date => "$123.45"}
    end

    test "it should return an error when the coin id is not existing" do
      assert {:error, :no_crypto_found} = CoinGecko.get_coin_data("notACoin")
    end

    test "it should return an error when something went wrong with the api" do
      assert {:error, :coin_gecko_api_error} = CoinGecko.get_coin_data("errorMock")
    end
  end

  describe "search_coin/2" do
    test "it should return the formmated search result" do
      {:ok, %{1 => bitcoin, 19 => _hbtc, 60 => _wbtc}} = CoinGecko.search_coin("bitcoin", 5)

      assert %{name: "Bitcoin", thumb: thumb} = bitcoin
      assert is_binary(thumb)
    end

    test "it should limit the results" do
      {:ok, data} = CoinGecko.search_coin("bitcoin", 2)
      assert Enum.count(data) == 2
    end

    test "it should return an error when a crypto coin search returns no result" do
      assert {:error, :no_crypto_found} = CoinGecko.search_coin("notACoin", 5)
    end

    test "it should return an error when something went wrong with the api" do
      assert {:error, :coin_gecko_api_error} = CoinGecko.search_coin("errorMock", 5)
    end
  end
end
