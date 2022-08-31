defmodule Cryptobot.Repo do
  use Ecto.Repo,
    otp_app: :cryptobot,
    adapter: Ecto.Adapters.Postgres
end
