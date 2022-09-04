defmodule CryptobotWeb.Webhooks.FacebookController do
  use CryptobotWeb, :controller

  alias CryptobotWeb.Services.Api.Facebook.EventHandler
  @verification_token Application.get_env(:cryptobot, :facebook)[:verification_token]

  def handle_event(conn, %{"hub.challenge" => hub_challenge, "mode" => mode, "token" => token}) do
    case mode == "subscribe" && token == @verification_token do
      true ->
        send_resp(conn, :ok, hub_challenge)

      _ ->
        send_resp(conn, :forbidden, "")
    end
  end

  def handle_event(conn, %{"entry" => entry}) do
    Task.start_link(fn -> EventHandler.parse(entry) end)
    send_resp(conn, 200, "")
  end
end
