defmodule Mafia.Joken do
  use Joken.Config


  def token_config do
    %{}
    |> add_claim("iss", fn -> "mafia" end, &(&1 == "mafia"))
  end

end