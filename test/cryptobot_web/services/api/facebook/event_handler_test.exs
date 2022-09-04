defmodule CryptobotWeb.Services.Api.Facebook.EventHandlerTest do
  use Cryptobot.DataCase

  import ExUnit.CaptureLog

  alias CryptobotWeb.Services.Api.Facebook.EventHandler

  describe "parse/1" do
    test "it should handle GET_STARTED event" do
      assert {:ok, :success} =
               EventHandler.parse([
                 %{
                   "messaging" => [
                     %{
                       "postback" => %{
                         "payload" => "GET_STARTED"
                       },
                       "sender" => %{"id" => "validSenderId"}
                     }
                   ]
                 }
               ])
    end

    test "it should handle SEARCH_BY_NAME event" do
      assert {:ok, :success} =
               EventHandler.parse([
                 %{
                   "messaging" => [
                     %{
                       "postback" => %{
                         "payload" => "SEARCH_BY_NAME"
                       },
                       "sender" => %{"id" => "validSenderId"}
                     }
                   ]
                 }
               ])

      assert [{"validSenderId", :search_by_name}] =
               :ets.lookup(:user_input_cache, "validSenderId")
    end

    test "it should handle SEARCH_BY_ID event" do
      assert {:ok, :success} =
               EventHandler.parse([
                 %{
                   "messaging" => [
                     %{
                       "postback" => %{
                         "payload" => "SEARCH_BY_ID"
                       },
                       "sender" => %{"id" => "validSenderId"}
                     }
                   ]
                 }
               ])

      assert [{"validSenderId", :search_by_id}] = :ets.lookup(:user_input_cache, "validSenderId")
    end

    test "it should handle the event when a user choose a coin from the carousel" do
      :ets.insert(:user_input_cache, {"validSenderId", :search_by_id})

      assert {:ok, :success} =
               EventHandler.parse([
                 %{
                   "messaging" => [
                     %{
                       "postback" => %{
                         "payload" => "COIN_ID_bitcoin"
                       },
                       "sender" => %{"id" => "validSenderId"}
                     }
                   ]
                 }
               ])

      assert [] = :ets.lookup(:user_input_cache, "validSenderId")
    end

    test "it should handle the event when a user sends a REPLY after choosing SEARCH BY NAME button" do
      :ets.insert(:user_input_cache, {"validSenderId", :search_by_name})

      assert {:ok, :success} =
               EventHandler.parse([
                 %{
                   "messaging" => [
                     %{
                       "message" => %{
                         "text" => "bitcoin"
                       },
                       "sender" => %{
                         "id" => "validSenderId"
                       }
                     }
                   ]
                 }
               ])
    end

    test "it should handle the event when a user sends a REPLY after choosing SEARCH BY ID button" do
      :ets.insert(:user_input_cache, {"validSenderId", :search_by_id})

      assert {:ok, :success} =
               EventHandler.parse([
                 %{
                   "messaging" => [
                     %{
                       "message" => %{
                         "text" => "bitcoin"
                       },
                       "sender" => %{
                         "id" => "validSenderId"
                       }
                     }
                   ]
                 }
               ])
    end
  end

  test "it should handle the event when a user sends a Message" do
    assert {:ok, :success} =
             EventHandler.parse([
               %{
                 "messaging" => [
                   %{
                     "message" => %{
                       "text" => "bitcoin"
                     },
                     "sender" => %{
                       "id" => "validSenderId"
                     }
                   }
                 ]
               }
             ])
  end

  test "it should log an error when there is an unexpected event" do
    assert capture_log(fn ->
             EventHandler.parse([%{"UnExpected" => "Event"}])
           end) =~ "This Webhook cannot be parsed"
  end
end
