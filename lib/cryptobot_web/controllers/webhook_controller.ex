defmodule CryptobotWeb.WebhookController do
  use CryptobotWeb, :controller

  def verify(conn, %{"hub.challenge" => hub_challenge}) do
    send_resp(conn, 200, hub_challenge)
  end
end