defmodule MafiaWeb.UserVoteLive.FormComponent do
  use MafiaWeb, :live_component

  alias Mafia.Accounts

  @impl true
  def update(%{user_vote: user_vote} = assigns, socket) do
    changeset = Accounts.change_user_vote(user_vote)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_vote" => user_vote_params}, socket) do
    changeset =
      socket.assigns.user_vote
      |> Accounts.change_user_vote(user_vote_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user_vote" => user_vote_params}, socket) do
    save_user_vote(socket, socket.assigns.action, user_vote_params)
  end

  defp save_user_vote(socket, :edit, user_vote_params) do
    case Accounts.update_user_vote(socket.assigns.user_vote, user_vote_params) do
      {:ok, _user_vote} ->
        {:noreply,
         socket
         |> put_flash(:info, "User vote updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user_vote(socket, :new, user_vote_params) do
    case Accounts.create_user_vote(user_vote_params) do
      {:ok, _user_vote} ->
        {:noreply,
         socket
         |> put_flash(:info, "User vote created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
