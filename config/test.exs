import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :cryptobot, Cryptobot.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "cryptobot_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cryptobot, CryptobotWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "fAzeVMx6cYxeaO9PQRClHGXD5BZiMCdpKWERdT5FZ4L48atuMKWS+TN5NLsaLf6X",
  server: false

# In test we don't send emails.
config :cryptobot, Cryptobot.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :cryptobot, :coin_gecko,
  api_url: "https://test-coin-gecko.com/api/v3/",
  coin_gecko_api: Cryptobot.Mocks.CoinGeckoMock

config :cryptobot, :facebook,
  api_url: "https://test.facebook.com/v14.0/me/",
  facebook_api: Cryptobot.Mocks.FacebookMock,
  access_token: "testFacebookToken",
  verification_token: "testVerificationToken"
