defmodule MafiaWeb.UserVoteLive.Index do
  use MafiaWeb, :live_view

  alias Mafia.Accounts
  alias Mafia.Accounts.UserVote

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :user_vote_collection, list_user_vote())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User vote")
    |> assign(:user_vote, Accounts.get_user_vote!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User vote")
    |> assign(:user_vote, %UserVote{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing User vote")
    |> assign(:user_vote, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_vote = Accounts.get_user_vote!(id)
    {:ok, _} = Accounts.delete_user_vote(user_vote)

    {:noreply, assign(socket, :user_vote_collection, list_user_vote())}
  end

  defp list_user_vote do
    Accounts.list_user_vote()
  end
end
