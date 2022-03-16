defmodule MafiaWeb.UserSessionTotalPointLive.Index do
  use MafiaWeb, :live_view

  alias Mafia.Accounts
  alias Mafia.Accounts.UserSessionTotalPoint

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :user_session_total_point_collection, list_user_session_total_point())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User session total point")
    |> assign(:user_session_total_point, Accounts.get_user_session_total_point!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User session total point")
    |> assign(:user_session_total_point, %UserSessionTotalPoint{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User session total point")
    |> assign(:user_session_total_point, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_session_total_point = Accounts.get_user_session_total_point!(id)
    {:ok, _} = Accounts.delete_user_session_total_point(user_session_total_point)

    {:noreply, assign(socket, :user_session_total_point_collection, list_user_session_total_point())}
  end

  defp list_user_session_total_point do
    Accounts.list_user_session_total_point()
  end
end
