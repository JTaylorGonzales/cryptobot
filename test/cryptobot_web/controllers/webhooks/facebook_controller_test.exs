defmodule CryptobotWeb.Webhooks.FacebookControllerTest do
  use CryptobotWeb.ConnCase

  describe "GET handle_event/2" do
    test "should verify verify the hub challenge", %{conn: conn} do
      conn =
        get(
          conn,
          Routes.facebook_path(conn, :handle_event, %{
            "hub.challenge" => "test_challenge",
            "hub.mode" => "subscribe",
            "hub.verify_token" => Application.get_env(:cryptobot, :facebook)[:verification_token]
          })
        )

      assert %{status: 200, resp_body: "test_challenge"} = conn
    end
  end
end
