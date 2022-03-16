defmodule MafiaWeb.UserLive.Index do
  use MafiaWeb, :live_view

  alias Mafia.Accounts
  alias Mafia.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :user_collection, list_user())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User")
    |> assign(:user, Accounts.get_user!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User")
    |> assign(:user, %User{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User")
    |> assign(:user, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user, %{is_deleted: true})

    {:noreply, assign(socket, :user_collection, list_user())}
  end

  defp list_user do
    Accounts.list_user()
  end
end
