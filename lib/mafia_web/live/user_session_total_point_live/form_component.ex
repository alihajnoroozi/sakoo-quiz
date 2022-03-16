defmodule MafiaWeb.UserSessionTotalPointLive.FormComponent do
  use MafiaWeb, :live_component

  alias Mafia.Accounts

  @impl true
  def update(%{user_session_total_point: user_session_total_point} = assigns, socket) do
    changeset = Accounts.change_user_session_total_point(user_session_total_point)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user_session_total_point" => user_session_total_point_params}, socket) do
    changeset =
      socket.assigns.user_session_total_point
      |> Accounts.change_user_session_total_point(user_session_total_point_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user_session_total_point" => user_session_total_point_params}, socket) do
    save_user_session_total_point(socket, socket.assigns.action, user_session_total_point_params)
  end

  defp save_user_session_total_point(socket, :edit, user_session_total_point_params) do
    case Accounts.update_user_session_total_point(socket.assigns.user_session_total_point, user_session_total_point_params) do
      {:ok, _user_session_total_point} ->
        {:noreply,
         socket
         |> put_flash(:info, "User session total point updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user_session_total_point(socket, :new, user_session_total_point_params) do
    case Accounts.create_user_session_total_point(user_session_total_point_params) do
      {:ok, _user_session_total_point} ->
        {:noreply,
         socket
         |> put_flash(:info, "User session total point created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
