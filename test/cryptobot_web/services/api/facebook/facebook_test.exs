defmodule CryptobotWeb.Services.Api.FacebookTest do
  use Cryptobot.DataCase

  import ExUnit.CaptureLog

  alias CryptobotWeb.Services.Api.Facebook

  describe "send_message/1" do
    test "should return success when the payload and access token is valid" do
      assert {:ok, :success} =
               Facebook.send_message(%{
                 message: %{text: "Cool, Whats the Name of the Crypto?"},
                 messaging_type: "RESPONSE",
                 recipient: %{id: "validSenderId"}
               })
    end

    test "should log an error when access token expires" do
      assert capture_log(fn ->
               Facebook.send_message(%{access_token_expired: "mock"})
             end) =~ "Refresh token needs to be refreshed"
    end

    test "should log an error when receiving an unexpected response" do
      assert capture_log(fn ->
               Facebook.send_message(%{unexpected_response: "mock"})
             end) =~ "Failed to send a response"
    end

    test "should log an error when receiving an unexpected error" do
      assert capture_log(fn ->
               Facebook.send_message(%{unexpected_error: "mock"})
             end) =~ "Unexpected error:"
    end
  end
end
