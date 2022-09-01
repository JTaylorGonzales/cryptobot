defmodule CryptobotWeb.Services.Api.FacebookApi do
  use HTTPoison.Base

  @url "https://graph.facebook.com/v14.0/me/"

  def process_url(url), do: @url <> url

  def process_request_body(body), do: Jason.encode!(body)

  def process_response_body(body), do: Jason.decode!(body)
end
