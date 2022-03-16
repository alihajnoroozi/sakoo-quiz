defmodule Mafia.Presence do
  use Phoenix.Presence, otp_app: :mafia, pubsub_server: Mafia.PubSub
end