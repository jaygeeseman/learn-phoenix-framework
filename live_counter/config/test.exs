import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_counter, LiveCounterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "eB3XBujYkrQrgJgaUOfIeQrtdD4/+vtcohUxo2gdRStlFEa5pMpnQB/JgJ5B1MjP",
  server: false

# In test we don't send emails.
config :live_counter, LiveCounter.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
