defmodule Sms do
  require Logger


  def send_text_message(to, message) do
    if Mix.env() in [:dev, :test] do
    :ok
    else
    # final_url = Enum.join([System.fetch_env!("SMS_SERVER") <> "?", "mobile=" <> to, "message=" <> message], "&")
    final_url = Enum.join(["localhost:80" <> "?", "mobile=" <> to, "message=" <> message], "&")
    IO.inspect(URI.encode(final_url))
    # headers = ["token": System.fetch_env!("NOME_AUTHORIZATION_TOKEN"), "Accept": "Application/json; Charset=utf-8"]
    headers = ["Accept": "Application/json; Charset=utf-8"]
    HTTPoison.get!(URI.encode(final_url), headers)
    |> handle_response
    end
  end

  defp handle_response(%HTTPoison.Response{body: resp, status_code: status_code}) do
    Logger.info "#{resp}, #{status_code}"
    {_, result} = Jason.decode(resp)
    case Map.get(result, "status") do
      200 ->
        :ok
      _ ->
        :error
    end
  end

end
