defmodule LiveCounter.Presence do
@moduledoc """
Enables tracking of presence
"""
  use Phoenix.Presence,
    otp_app: :live_counter,
    pubsub_server: LiveCounter.PubSub
end
