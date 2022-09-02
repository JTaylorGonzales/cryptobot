defmodule CryptobotWeb.Services.Api.Facebook do
  @api CryptobotWeb.Services.Api.FacebookApi
  @token "EAAFIKUmZBM3wBAJah1CFSYLbau0zTqzDbaQACT2ZAd2fnxIq4H1ohruB7BxRrBXr5972epursBKdpnwgcTyTFuSrxOaweHCejQnxoyodUUO7DYCvEJNyuJKA342PcmWaJ6uSBFzeEXVCg4p9PMQiZA8b2uOTVSqmw1RFSw8D8YsklqaoHZARo1U9ua5qVS1ZBYcGmBkZAenwZDZD"

  def set_greeting do
    body =
      Jason.encode!(%{
        greeting: [
          %{
            locale: "default",
            text: "Hello {{user_first_name}}! welcome to CryptoBot the best crypto bot"
          }
        ]
      })

    @api.post("messenger_profile?access_token=#{@token}", body, [
      {"Content-Type", "application/json"}
    ])
  end

  def set_get_started do
    body =
      Jason.encode!(%{
        get_started: %{
          payload: "GET_STARTED"
        }
      })

    @api.post("messenger_profile?access_token=#{@token}", body, [
      {"Content-Type", "application/json"}
    ])
  end

  def send_message(body) do
    @api.post("messages?access_token=#{@token}", body, [
      {"Content-Type", "application/json"}
    ])
    |> IO.inspect()
  end
end
