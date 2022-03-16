defmodule MafiaWeb.Plug.EnsureUserLoggedIn do
  @moduledoc """
  This plug makes sure that the authenticated user is a super user,
  otherwise it halts the connection.
  """
  import Plug.Conn
  import Phoenix.Controller
  alias Survey.Repo
  alias Survey.Accounts.User
  import Ecto.Query, warn: false

  require Logger

  def init(opts), do: Enum.into(opts, %{})

  def call(conn, opts \\ []) do
    check_if_user_logged_in(conn, opts)
  end

  defp check_if_user_logged_in(conn, _opts) do
    access_token = Map.get(conn.cookies, "token")
    if access_token do
      case Mafia.Sessions.get_claims_from_jwt_token(access_token) do
        {:ok, claim} ->
#          IO.inspect(claim)
          user_id = Mafia.Utility.parsInt(Map.get(claim, "sub"))
          is_admin = case Map.get(claim, "is_admin") do
            "true" ->
              true
            "false" ->
              false
            _ ->
              false
          end
          mobile = Map.get(claim, "mobile")
          conn
          |> put_session("user", %{ id: user_id, mobile: mobile, is_admin: is_admin})
        _ ->
          halt_plug(conn)
      end
    else
      halt_plug(conn)
    end

  end

  defp halt_plug(conn) do
    body = Jason.encode!(%{message: "Access Forbidden"})

    conn
    |> redirect(to: "/signin")
    |> halt()
  end

  defp auth_error!(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(MafiaWeb.ErrorView, "401.json")
    |> halt
  end
end
