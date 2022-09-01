defmodule CryptobotWeb.Services.Api.Facebook.Templates do
  def get_started_template(sender_id) do
    %{
      recipient: %{
        id: sender_id
      },
      messaging_type: "RESPONSE",
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "button",
            text: "Choose on how you want to search a crypto:",
            buttons: [
              %{
                type: "postback",
                title: "Search Crypto by Name",
                payload: "SEARCH_BY_NAME"
              },
              %{
                type: "postback",
                title: "Search Crypto by ID",
                payload: "SEARCH_BY_ID"
              }
            ]
          }
        }
      }
    }
  end

  def search_by_template(sender_id, query) do
    %{
      recipient: %{
        id: sender_id
      },
      messaging_type: "RESPONSE",
      message: %{
        text: "Cool, Whats the #{query} of the Crypto?"
      }
    }
  end
end
