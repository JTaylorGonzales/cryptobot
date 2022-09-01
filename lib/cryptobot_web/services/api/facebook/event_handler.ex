defmodule CryptobotWeb.Services.Api.Facebook.EventHandler do
  alias CryptobotWeb.Services.Api.{
    CryptoMarket.CoinGecko,
    Facebook,
    Facebook.Templates
  }

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
    :ets.insert(:user_input_cache, {sender_id, :search_by_name})

    sender_id
    |> Templates.search_by_template("Name")
    |> Facebook.send_message()
  end

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

  def handle_reply([], sender_id, _text) do
    sender_id
    |> Templates.reply_cannot_be_parsed_template()
    |> Facebook.send_message()
  end

  def handle_reply([{sender_id, :search_by_name} | _t], sender_id, text) do
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

    sender_id
    |> Templates.get_started_template()
    |> Facebook.send_message()
  end

  def handle_reply([{sender_id, :search_by_id} | _t], sender_id, text) do
    template =
      case CoinGecko.get_coin_data(text) do
        {:ok, coin_data} ->
          Templates.coin_market_history_template(sender_id, coin_data)

        {:error, :no_crypto_found} ->
          Templates.coin_not_found_template(sender_id)

        {:error, _error} ->
          Templates.generic_try_again_template(sender_id)
      end

    Facebook.send_message(template)
    :ets.delete(:user_input_cache, sender_id)

    sender_id
    |> Templates.get_started_template()
    |> Facebook.send_message()
  end

  def parse(_) do
    nil
  end
end
