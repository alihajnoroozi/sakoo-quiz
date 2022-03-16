defmodule MafiaWeb.SessionLive.FormComponent do
  use MafiaWeb, :live_component

  alias Mafia.Game

  @impl true
  def update(%{session: session} = assigns, socket) do
    changeset = Game.change_session(session)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"session" => session_params}, socket) do
    changeset =
      socket.assigns.session
      |> Game.change_session(session_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"session" => session_params}, socket) do
    save_session(socket, socket.assigns.action, session_params)
  end

  defp save_session(socket, :edit, session_params) do
    case Game.update_session(socket.assigns.session, session_params) do
      {:ok, _session} ->
        {:noreply,
         socket
         |> put_flash(:info, "اطلاعات مسابقه با موفقیت به روز شد")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_session(socket, :new, session_params) do
    case Game.create_session(session_params) do
      {:ok, _session} ->
        {:noreply,
         socket
         |> put_flash(:info, "مسابقه جدید با موفقیت ایجاد شد")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
