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
end
