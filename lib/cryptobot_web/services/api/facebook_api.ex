defmodule CryptobotWeb.Services.Api.FacebookApi do
  use HTTPoison.Base

  @url "https://graph.facebook.com/v14.0/me/messages?"

  def process_url(url), do: @url <> url

  def process_response_body(body), do: Jason.decode!(body)
end
