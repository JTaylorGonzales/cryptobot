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
            text: "Do you want to search a crypto? Choose on how you want to: ",
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
    generic_text_reply(sender_id, "RESPONSE", "Cool, Whats the #{query} of the Crypto?")
  end

  def coins_found_template(sender_id) do
    generic_text_reply(sender_id, "RESPONSE", "Here are the top 5 Coins found: ")
  end

  def reply_cannot_be_parsed_template(sender_id) do
    generic_text_reply(sender_id, "RESPONSE", "Sorry your I can't process your response")
  end

  def coins_carousel_template(sender_id, coins) do
    elements =
      Enum.map(coins, fn {rank, %{name: name, thumb: thumb_url, id: coin_id}} ->
        %{
          title: name,
          subtitle: "Market Cap Rank: #{rank}",
          image_url: thumb_url,
          buttons: [
            %{
              type: "postback",
              title: "Market History",
              payload: "COIN_ID_#{coin_id} #{name}"
            }
          ]
        }
      end)

    %{
      recipient: %{
        id: sender_id
      },
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "generic",
            elements: elements
          }
        }
      }
    }
  end

  def coin_not_found_template(sender_id) do
    generic_text_reply(
      sender_id,
      "RESPONSE",
      "Sorry, We cannot find the coin you're looking at. Please Try again."
    )
  end

  def coin_market_history_template(sender_id, coin_data) do
    txt = "Here is the 14 day market History \n"

    text =
      Enum.reduce(coin_data, txt, fn {date, price}, acc ->
        acc <> "\n #{date}: #{price}"
      end)

    generic_text_reply(sender_id, "RESPONSE", text)
  end

  def generic_try_again_template(sender_id) do
    generic_text_reply(
      sender_id,
      "RESPONSE",
      "Sorry, Something Went wrong upon processing your request. Please Try again."
    )
  end

  defp generic_text_reply(sender_id, type, text) do
    %{
      recipient: %{
        id: sender_id
      },
      messaging_type: type,
      message: %{
        text: text
      }
    }
  end
end
