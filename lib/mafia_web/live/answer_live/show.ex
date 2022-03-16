defmodule MafiaWeb.AnswerLive.Show do
  use MafiaWeb, :live_view

  alias Mafia.Game

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:answer, Game.get_answer!(id))}
  end

  defp page_title(:show), do: "Show Answer"
  defp page_title(:edit), do: "Edit Answer"
end
