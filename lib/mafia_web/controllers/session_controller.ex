defmodule MafiaWeb.SessionController do
  use MafiaWeb, :controller

  require Logger

  def login(conn, %{"user_id" => user_id, "role" => is_admin, "mobile" => mobile}) do
#    Logger.info("To controller")
#    IO.inspect(conn.cookies)
#    IO.inspect(fetch_cookies(conn))
    access_token = Mafia.Sessions.generate_jwt_token!(
      %{
        mobile: mobile,
        is_admin: is_admin,
        sub: user_id,
        token_type: "access",
        exp: Mafia.DatetimeUtility.add_time_in_timestamp!(30, :day)
      }
    )
#    cart = get_session(conn, "test_session") || []
    conn
    |> put_session("user", %{ id: user_id, mobile: mobile, is_admin: is_admin})
    |> put_resp_cookie("token", access_token,
         http_only: true,
         max_age: 86400,
       )
    |> redirect(to: "/")
  end

  def logout(conn, _) do
    conn
    |> redirect(to: "/signin")
  end
end
