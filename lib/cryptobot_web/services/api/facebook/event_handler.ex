defmodule CryptobotWeb.Services.Api.Facebook.EventHandler do
  alias CryptobotWeb.Services.Api.Facebook
  alias CryptobotWeb.Services.Api.Facebook.Templates

  def parse([
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "GET_STARTED"
              },
              "sender" => %{"id" => sender_id}
            }
            | _t
          ]
        }
      ]) do
    sender_id
    |> Templates.get_started_template()
    |> Facebook.send_message()
  end

  def parse([
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "SEARCH_BY_NAME"
              },
              "sender" => %{"id" => sender_id}
            }
            | _t
          ]
        }
      ]) do
    sender_id
    |> Templates.search_by_template("Name")
    |> Facebook.send_message()
  end

  def parse([
        %{
          "messaging" => [
            %{
              "message" => %{
                "text" => text
              }
            }
            | _t
          ]
        }
      ]) do
  end

  def parse(_) do
    nil
  end
end
