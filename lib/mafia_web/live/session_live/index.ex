defmodule MafiaWeb.SessionLive.Index do
  use MafiaWeb, :live_view

  alias Mafia.Game
  alias Mafia.Game.Session

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Mafia.Game.subscribe()
    end
    current_game_id = case (Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_current_game_id")) do
      {:ok, nil} ->
        nil
      {:ok, value} ->
        Mafia.Utility.parsInt(value)
      _ ->
        nil
    end
    is_playing = case (Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_is_playing")) do
      {:ok, nil} ->
        false
      {:ok, value} ->
        if value == "1" do true else false end
      _ ->
        false
    end
    {
      :ok,
      socket
      |> assign(:is_playing, is_playing)
      |> assign(:current_game_id, current_game_id)
      |> assign(:session_collection, list_session())
    }

  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "ویراش مسابقه")
    |> assign(:session, Game.get_session!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "ایجاد مسابقه جدید")
    |> assign(:session, %Session{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "لیست مسابقات")
    |> assign(:session, nil)
  end

  def handle_event("start_game", %{"sessionid" => session_id}, socket) do

    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_current_game_id", session_id)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_is_playing", 1)
    session = Mafia.Game.get_session!(session_id)
#    questions = Mafia.Game.get!()
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_current_session_id", session.id)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_user_can_attend_in_play_page", 1)
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_correct_option_id")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_correct_option_point")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_current_question_id")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_current_question")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_current_options")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_is_question_showing")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_is_question_showing")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_is_leaderboard_calculating")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_is_leaderboard_ready_" <> session_id)
    Mafia.Game.broadcast(session, :game_started)
    {
      :noreply,
      redirect(socket, to: "/super-admin/session/contest/" <> session_id)
    }
  end


  def handle_event("game_page", %{"sessionid" => session_id}, socket) do

    {
      :noreply,
      redirect(socket, to: "/super-admin/session/contest/" <> session_id)
    }
  end


  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    session = Game.get_session!(id)
    {:ok, _} = Game.delete_session(session, %{is_deleted: true})

    {:noreply, assign(socket, :session_collection, list_session())}
  end

#  @impl true
#  def handle_info({:game_started, message}, socket) do
#    IO.inspect("To session list info hastimmm")
#    {:noreply, socket}
#  end

#  @impl true
#  def handle_info({:game_ended, message}, socket) do
#    {:noreply, update(socket, :is_playing, false)}
#  end

  defp list_session do
    Game.list_session()
  end

  @impl true
  def handle_info({:online_user_updated, message}, socket) do
    {
      :noreply,
      socket
    }
  end
end
