defmodule CryptobotWeb.Webhooks.FacebookController do
  use CryptobotWeb, :controller

  alias CryptobotWeb.Services.Api.Facebook.EventHandler
  @verification_token Application.get_env(:cryptobot, :facebook)[:verification_token]

  @moduledoc """
    this module is responsible for handling webhooks sent by facebook
  """
  # this function is responsible for handling the callback verification of facebook
  def handle_event(conn, %{
        "hub.challenge" => hub_challenge,
        "hub.mode" => mode,
        "hub.verify_token" => token
      }) do
    case mode == "subscribe" && token == @verification_token do
      true ->
        send_resp(conn, :ok, hub_challenge)

      _ ->
        send_resp(conn, :forbidden, "")
    end
  end

  # starts a supervised process when a webhook has been received
  # and asynchronously send a 200 response so that the processing
  # of webhooks wont be blocked
  def handle_event(conn, %{"entry" => entry}) do
    Task.Supervisor.start_child(EventHandlerSupervisor, fn -> EventHandler.parse(entry) end)
    send_resp(conn, 200, "")
  end

  def handle_event(conn, _params), do: send_resp(conn, 200, "")
end
