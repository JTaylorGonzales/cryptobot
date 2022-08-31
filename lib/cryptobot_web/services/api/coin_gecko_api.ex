defmodule CryptobotWeb.Services.Api.CoinGeckoApi do
  use HTTPoison.Base

  @url Application.get_env(:cryptobot, :coin_gecko)[:api_url]

  def process_url(url), do: @url <> url

  def process_response_body(body), do: Jason.decode!(body)
end
