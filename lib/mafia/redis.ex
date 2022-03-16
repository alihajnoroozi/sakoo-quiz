defmodule Mafia.Redis do

  def get_connection do
    RedisConnection
  end

  def get_by_key!(key) do
    conn = get_connection
    case Redix.command(conn, ["GET", key]) do
      {:ok, result} ->
        result
      {:error, reason} ->
        false
      :error ->
        false
    end

  end

  def get_by_key(key) do
    Redix.command(get_connection, ["GET", key])
  end

  def del_by_key(key) do
    Redix.command(get_connection, ["SET", key, "", "EX", 1])
  end

  def set_by_key(key, value) do
    Redix.command(get_connection, ["SET", key, value])
  end

  def inc_by_key(key) do
    Redix.command(get_connection, ["INCR", key])
  end

  def dec_by_key(key) do
    Redix.command(get_connection, ["DECR", key])
  end


  def get_key_list_by_patters(pattern_key) do
    Redix.command(get_connection, ["KEYS", "#{pattern_key}*"])
  end


end