defmodule CryptobotWeb.Services.Api.Facebook do
  @api CryptobotWeb.Services.Api.FacebookApi
  @token "EAAFIKUmZBM3wBACCa7cYDrGnoLzUwujv8f1Rr1qZAhssIC3VV8P5ZAE0ttU0FO8NLLThV4rZC0y1ZCZBCbaijpu9n7psywbJkMxseZCuPgZAJA8spsFFrRuDbTL2SzeKcVGhzVtegh5qXbFYNtoXeUgnP2P0YuZBeYjbUsF2o5ZAgaf9nIkvxnhGXsGu0oFkOcdT2SC6x7MOWK4AZDZD"

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
  end
end
