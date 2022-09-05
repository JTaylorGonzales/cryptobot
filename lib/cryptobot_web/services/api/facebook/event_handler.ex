defmodule CryptobotWeb.Services.Api.Facebook.EventHandler do
  alias CryptobotWeb.Services.Api.{
    CryptoMarket.CoinGecko,
    Facebook,
    Facebook.Templates
  }

  require Logger

  @moduledoc """
    this module is responsible for handling all of the valid webhooks that we are expected to parse
  """
  @doc """
    This function pattern matches the incoming webhooks sent by Facebook.
  """
  # handles the event when a user clicks the "Get Started" button when interacting with the chatbot for the firs time
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
    send_get_started_template(sender_id)
  end

  # handles the event when a user choose the button: `Search Crypto By Name`
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
    :ets.insert(:user_input_cache, {sender_id, :search_by_name})

    sender_id
    |> Templates.search_by_template("Name")
    |> Facebook.send_message()
  end

  # handles the event when a user choose the button: `Search Crypto By ID`
  def parse([
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "SEARCH_BY_ID"
              },
              "sender" => %{"id" => sender_id}
            }
            | _t
          ]
        }
      ]) do
    :ets.insert(:user_input_cache, {sender_id, :search_by_id})

    sender_id
    |> Templates.search_by_template("ID")
    |> Facebook.send_message()
  end

  # handles the event when a user choose a coin from the COIN carousel when searching for a crypto by name
  def parse([
        %{
          "messaging" => [
            %{
              "postback" => %{
                "payload" => "COIN_ID_" <> coin_id
              },
              "sender" => %{"id" => sender_id}
            }
            | _t
          ]
        }
      ]) do
    handle_reply([{sender_id, :search_by_id}], sender_id, coin_id)
  end

  # handles the event when a user send a text message
  def parse([
        %{
          "messaging" => [
            %{
              "message" => %{
                "text" => text
              },
              "sender" => %{
                "id" => sender_id
              }
            }
            | _t
          ]
        }
      ]) do
    :user_input_cache
    |> :ets.lookup(sender_id)
    |> handle_reply(sender_id, text)
  end

  # handles unexpected webhook events
  def parse(event) do
    unexpected_event = Jason.encode!(event)
    Logger.error("This Webhook cannot be parsed: #{unexpected_event}")
  end

  defp handle_reply([], sender_id, _text) do
    sender_id
    |> Templates.reply_cannot_be_parsed_template()
    |> Facebook.send_message()

    send_get_started_template(sender_id)
  end

  defp handle_reply([{sender_id, :search_by_name} | _t], sender_id, text) do
    template =
      case CoinGecko.search_coin(text, 5) do
        {:ok, coins} ->
          Templates.coins_carousel_template(sender_id, coins)

        {:error, :no_crypto_found} ->
          Templates.coin_not_found_template(sender_id)

        {:error, _error} ->
          Templates.generic_try_again_template(sender_id)
      end

    Facebook.send_message(template)
    :ets.delete(:user_input_cache, sender_id)

    send_get_started_template(sender_id)
  end

  defp handle_reply([{sender_id, :search_by_id} | _t], sender_id, coin_id) do
    template =
      case CoinGecko.get_coin_data(coin_id) do
        {:ok, coin_data} ->
          Templates.coin_market_history_template(sender_id, coin_data)

        {:error, :no_crypto_found} ->
          Templates.coin_not_found_template(sender_id)

        {:error, _error} ->
          Templates.generic_try_again_template(sender_id)
      end

    Facebook.send_message(template)
    :ets.delete(:user_input_cache, sender_id)

    send_get_started_template(sender_id)
  end

  defp send_get_started_template(sender_id) do
    sender_id
    |> Templates.get_started_template()
    |> Facebook.send_message()
  end
end
