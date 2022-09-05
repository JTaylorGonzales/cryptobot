defmodule CryptobotWeb.Services.Api.Facebook do
  require Logger
  @api Application.get_env(:cryptobot, :facebook)[:facebook_api]
  @token Application.get_env(:cryptobot, :facebook)[:access_token]

  @moduledoc """
    this module is responsible for building the complete API calls to facebook API.
    and logs all the unexpected errors
  """
  @spec send_message(map) ::
          {:error, :unexpected_error | [{:status_code, 401 | 500}, ...]} | {:ok, :success}
  def send_message(body) do
    case @api.post("messages?access_token=#{@token}", body) do
      {:ok, %{status_code: 200}} ->
        {:ok, :success}

      {:ok, %{status_code: 401}} ->
        Logger.critical("Refresh token needs to be refreshed")
        {:error, status_code: 401}

      {:ok, %{status_code: status_code, body: body}} ->
        response = Jason.encode!(body)

        Logger.error(
          "Failed to send a response. status_code: #{status_code}, response: #{response} "
        )

        {:error, status_code: status_code}

      {:error, error} ->
        Logger.error("Unexpected error: #{error}")
        {:error, :unexpected_error}
    end
  end
end
