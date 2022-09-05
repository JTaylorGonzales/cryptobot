defmodule Cryptobot.Mocks.FacebookMock do
  @doc """
    This module is responsible for mocking the responses for facebook API calls
  """

  # this function will mock the response for the event: `GET STARTED`
  def post(
        "messages?access_token=testFacebookToken",
        %{
          message: %{
            attachment: %{
              payload: %{
                buttons: [
                  %{
                    payload: "SEARCH_BY_NAME",
                    title: "Search Crypto by Name",
                    type: "postback"
                  },
                  %{
                    payload: "SEARCH_BY_ID",
                    title: "Search Crypto by ID",
                    type: "postback"
                  }
                ],
                template_type: "button",
                text: "Do you want to search a crypto? Choose on how you want to: "
              },
              type: "template"
            }
          },
          messaging_type: "RESPONSE",
          recipient: %{id: "validSenderId"}
        }
      ) do
    {:ok, %{status_code: 200}}
  end

  # this function will mock the response for the event: SEARCH CRYPTO BY NAME
  def post("messages?access_token=testFacebookToken", %{
        message: %{text: "Cool, Whats the Name of the Crypto?"},
        messaging_type: "RESPONSE",
        recipient: %{id: "validSenderId"}
      }) do
    {:ok, %{status_code: 200}}
  end

  # this will mock the response for the event: SEARCH CRYPTO BY ID
  def post("messages?access_token=testFacebookToken", %{
        message: %{text: "Cool, Whats the ID of the Crypto?"},
        messaging_type: "RESPONSE",
        recipient: %{id: "validSenderId"}
      }) do
    {:ok, %{status_code: 200}}
  end

  # this will mock the response for the event: SUCCESSFULLY SEARCHING for a crypto by ID and CHOOSING a Crypto on the Coin Carousel
  def post("messages?access_token=testFacebookToken", %{
        message: %{
          text: "Here is the 14 day market History" <> _date
        },
        messaging_type: "RESPONSE",
        recipient: %{id: "validSenderId"}
      }) do
    {:ok, %{status_code: 200}}
  end

  # this will mock the response for the event: SUCCESSFULLY SEARCHING for a crypto by NAME
  def post(
        "messages?access_token=testFacebookToken",
        %{
          message: %{
            attachment: %{
              payload: %{
                elements: [
                  %{
                    buttons: [
                      %{
                        payload: "COIN_ID_bitcoin",
                        title: "Market History",
                        type: "postback"
                      }
                    ],
                    image_url: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png",
                    subtitle: "Market Cap Rank: 1",
                    title: "Bitcoin"
                  },
                  %{
                    buttons: [
                      %{
                        payload: "COIN_ID_wrapped-bitcoin",
                        title: "Market History",
                        type: "postback"
                      }
                    ],
                    image_url:
                      "https://assets.coingecko.com/coins/images/7598/large/wrapped_bitcoin_wbtc.png",
                    subtitle: "Market Cap Rank: 19",
                    title: "Wrapped Bitcoin"
                  },
                  %{
                    buttons: [
                      %{
                        payload: "COIN_ID_huobi-btc",
                        title: "Market History",
                        type: "postback"
                      }
                    ],
                    image_url:
                      "https://assets.coingecko.com/coins/images/12407/large/Unknown-5.png",
                    subtitle: "Market Cap Rank: 60",
                    title: "Huobi BTC"
                  }
                ],
                template_type: "generic"
              },
              type: "template"
            }
          },
          recipient: %{id: "validSenderId"}
        }
      ) do
    {:ok, %{status_code: 200}}
  end

  # this will mock the response for the event: A user sends a message without choosing Search By Crypto Name or ID
  def post("messages?access_token=testFacebookToken", %{
        message: %{text: "Sorry your I can't process your response"},
        messaging_type: "RESPONSE",
        recipient: %{id: "validSenderId"}
      }) do
    {:ok, %{status_code: 200}}
  end

  # this will mock the response for the event: FACEBOOK access token is expired
  def post("messages?access_token=testFacebookToken", %{access_token_expired: "mock"}) do
    {:ok, %{status_code: 401}}
  end

  # this will mock the response for the event: Unexpected Response from facebook
  def post("messages?access_token=testFacebookToken", %{unexpected_response: "mock"}) do
    {:ok, %{status_code: 500, body: %{message: "unexpected error occured"}}}
  end

  # this will mock the response for the event: Unexpected error occured
  def post("messages?access_token=testFacebookToken", %{unexpected_error: "mock"}) do
    {:error, :unexpected_error}
  end
end
