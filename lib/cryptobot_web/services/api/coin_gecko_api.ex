defmodule CryptobotWeb.Services.Api.CoinGeckoApi do
  use HTTPoison.Base

  @url Application.get_env(:cryptobot, :coin_gecko)[:api_url]

  @moduledoc """
    this module is responsible for decoding the response of Coingecko
  """

  def process_url(url), do: @url <> url

  def process_response_body(body), do: Jason.decode!(body)
end
