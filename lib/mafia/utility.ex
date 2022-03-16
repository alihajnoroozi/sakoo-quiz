defmodule Mafia.Utility do

  def parsInt(string) do
    {number, _} = Integer.parse(string)
    number
  end

  def key_value_to_atom_key(key_value) do
    for {key, val} <- key_value, into: %{}, do: {String.to_atom(key), val}
  end

  def hide_mobile_middle_numbers(mobile) do
    String.at(mobile, 0) <> String.at(mobile, 1) <> String.at(mobile, 2) <> String.at(mobile, 3) <> " * * * " <> String.at(mobile, 7)  <> String.at(mobile, 8) <> String.at(mobile, 9) <> String.at(mobile, 10)
  end

end