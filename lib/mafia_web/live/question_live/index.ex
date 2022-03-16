defmodule MafiaWeb.QuestionLive.Index do
  use MafiaWeb, :live_view

  alias Mafia.Game
  alias Mafia.Game.Question

  @impl true
  def mount(%{"session_id" => session_id}, _session, socket) do
    {:ok,
      socket
      |> assign(:question_collection, list_question(session_id))
      |> assign(:session_id, session_id)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "ویرایش سوال")
    |> assign(:question, Game.get_question!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "افزودن سوال جدید")
    |> assign(:question, %Question{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "لیست سوالات")
    |> assign(:question, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    question = Game.get_question!(id)
    {:ok, _} = Game.delete_question(question, %{is_deleted: true})
    session_id = socket.assigns.session_id
    {:noreply, assign(socket, :question_collection, list_question(session_id))}
  end

  defp list_question(session_id) do
    Game.list_question(session_id)
  end
end
