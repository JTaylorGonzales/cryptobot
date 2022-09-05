defmodule CryptobotWeb.Services.Api.FacebookApi do
  use HTTPoison.Base

  @url Application.get_env(:cryptobot, :facebook)[:api_url]

  @moduledoc """
    this module is responsible for encoding the body of the request
    and decoding the body of tthe response, and properly setting
    request headers
  """

  def process_url(url), do: @url <> url

  def process_request_headers(headers), do: [{"Content-Type", "application/json"} | headers]

  def process_request_body(body), do: Jason.encode!(body)

  def process_response_body(body), do: Jason.decode!(body)
end
