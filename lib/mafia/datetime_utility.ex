defmodule Mafia.DatetimeUtility do

  def generate_timestamp_from_date!(date) do
    date|> DateTime.to_unix()
  end

  def add_time_to_current_datetime!(number) do
    DateTime.utc_now() |> DateTime.add(number, :second)
  end

  def add_time_in_timestamp!(number, type) do
    number = case type do
      :second ->
        number
      :minute ->
        number * 60
      :hour ->
        number * 3600
      :day ->
        number * 86400
    end
    add_time_to_current_datetime!(number)
    |> generate_timestamp_from_date!
  end

  def generate_cookie_expiration_time!(number, type) do
    case type do
      :second ->
        number
      :minute ->
        number * 60
      :hour ->
        number * 3600
      :day ->
        number * 86400
    end
  end
end