defmodule MafiaWeb.Plug.EnsureSuperAdmin do
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
    check_super_user(conn, opts)
  end

  defp check_super_user(conn, _opts) do
    access_token = Map.get(conn.cookies, "token")
    if access_token do
      {:ok, claim} = Mafia.Sessions.get_claims_from_jwt_token(access_token)
      case Map.get(claim, "is_admin") do
        "true" ->
          conn
        "false" ->
          halt_plug(conn)
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
end
