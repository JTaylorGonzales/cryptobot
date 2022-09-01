defmodule CryptobotWeb.WebhookController do
  use CryptobotWeb, :controller

  alias CryptobotWeb.Services.Api.Facebook.EventHandler

  def handle_event(conn, %{"hub.challenge" => hub_challenge}) do
    send_resp(conn, 200, hub_challenge)
  end

  def handle_event(conn, %{"entry" => entry}) do
    EventHandler.parse(entry)
    send_resp(conn, 200, "")
  end
end
