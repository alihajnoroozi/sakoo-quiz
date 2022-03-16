defmodule MafiaWeb.AnswerLive.Index do
  use MafiaWeb, :live_view

  alias Mafia.Game
  alias Mafia.Game.Answer

  @impl true
  def mount(%{"question_id" => question_id, "session_id" => session_id}, _session, socket) do
    {
      :ok,
      socket
      |> assign(:answer_collection, list_answer(question_id))
      |> assign(:question_id, question_id)
      |> assign(:session_id, session_id)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "ویرایش گزینه")
    |> assign(:answer, Game.get_answer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "افزودن گزینه جدید")
    |> assign(:answer, %Answer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "لیست گزینه ها")
    |> assign(:answer, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    answer = Game.get_answer!(id)
    {:ok, _} = Game.delete_answer(answer, %{is_deleted: true})
    question_id = socket.assigns.question_id
    {:noreply, assign(socket, :answer_collection, list_answer(question_id))}
  end

  defp list_answer(question_id) do
    Game.list_answer(question_id)
  end
end
