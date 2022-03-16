defmodule MafiaWeb.UserSessionTotalPointLive.Show do
  use MafiaWeb, :live_view

  alias Mafia.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user_session_total_point, Accounts.get_user_session_total_point!(id))}
  end

  defp page_title(:show), do: "Show User session total point"
  defp page_title(:edit), do: "Edit User session total point"
end
