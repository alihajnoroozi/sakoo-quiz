defmodule MafiaWeb.UserContestLive.Performance do
  use MafiaWeb, :live_view
  require Logger
  alias Mafia.Presence

  @presence "mafia:presence"
  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Mafia.Game.subscribe()
      user = _session["user"]
#      {:ok, _} = Presence.track(
#        self(),
#        @presence,
#        user.id,
#        %{
#          joined_at: :os.system_time(:seconds)
#        }
#      )
#      Phoenix.PubSub.subscribe(Mafia.PubSub, @presence)
    current_session_id = Mafia.Redis.get_by_key!("#{Application.get_env(:mafia, :product_name)}_current_session_id")
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_online_users_#{current_session_id}_#{user.id}", "1")
    end

    online_users = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_online_users") do
      {:ok, nil} ->
        0
      {:ok, value} ->
        value
    end


    is_playing = case (Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_is_playing")) do
      {:ok, nil} ->
        false
      {:ok, value} ->
        if value == "1" do
          true
        else
          false
        end
      _ ->
        false
    end

    user_can_attend_in_play_page = case (Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_user_can_attend_in_play_page")) do
      {:ok, nil} ->
        false
      {:ok, value} ->
        if value == "1" do
          true
        else
          false
        end
      _ ->
        false
    end

    question = case (Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_current_question")) do
      {:ok, nil} ->
        %{}
      {:ok, value} ->
        {:ok, result} = Jason.decode(value, [{:keys, :atoms}])
        result
      _ ->
        %{}
    end

    is_question_showing = case (Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_is_question_showing")) do
      {:ok, nil} ->
        false
      {:ok, value} ->
        if value == "1" do
          true
        else
          false
        end
      _ ->
        false
    end

    options = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_current_options") do
      {:ok, nil} ->
        %{}
      {:ok, value} ->
        {:ok, result} = Jason.decode(value, [{:keys, :atoms}])
        result
      _ ->
        %{}
    end
    current_question_id = Mafia.Redis.get_by_key!("#{Application.get_env(:mafia, :product_name)}_current_question_id")
    current_session_id = Mafia.Redis.get_by_key!("#{Application.get_env(:mafia, :product_name)}_current_session_id")
    done_question_key = "#{Application.get_env(:mafia, :product_name)}_voted-#{current_session_id}-#{_session["user"].id}-#{current_question_id}"
    user_statistics_key = "#{Application.get_env(:mafia, :product_name)}_statistics-#{to_string(current_session_id)}-#{_session["user"].id}"
    has_voted = case (Mafia.Redis.get_by_key(done_question_key)) do
      {:ok, nil} ->
        false
      {:ok, value} ->
        true
      _ ->
        false
    end

    [user_total_point, user_leaderboard_data] = case Mafia.Redis.get_by_key(user_statistics_key) do
      {:ok, nil} ->
        [0, %{}]
      {:ok, value} ->
        {:ok, result} = Jason.decode(value, [{:keys, :atoms}])
        [result.total_point, result]
      _ ->
        [0, %{}]

    end

    changeset_verify = false
    [countdown, timer_object] = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_countdown_status") do
      {:ok, nil} ->
        [0, nil]
      {:ok, value} ->
        {:ok, timer} = :timer.send_interval(1000, self(), :tick)
        [Mafia.Utility.parsInt(value) - 2, timer]
      _ ->
       [0, nil]
    end

    is_leaderboard_ready = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_is_leaderboard_ready_#{current_session_id}") do
      {:ok, nil} ->
        false
      {:ok, "0"} ->
        false
      {:ok, "1"} ->
        true
      _ ->
        false
    end

    leaderboard_data = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_leaderboard_top_20_#{current_session_id}") do
      {:ok, nil} ->
        []
      {:ok, value} ->
        {:ok, result} = Jason.decode(value, [{:keys, :atoms}])
        result
      _ ->
        []
    end

#    [current_game_id, total_questions_count] = case (Mafia.Redis.get_by_key("current_game_id")) do
#      {:ok, nil} ->
#        [nil, []]
#      {:ok, value} ->
#
#      _ ->
#        [nil, []]
#    end
    total_questions_count = Mafia.Utility.parsInt(Mafia.Redis.get_by_key!("#{Application.get_env(:mafia, :product_name)}_total_questions_count")) #Mafia.Game.list_question(current_session_id)
#    IO.inspect(total_questions_count)

    if user_can_attend_in_play_page == true do
      {
        :ok,
        socket
        |> assign(:is_playing, is_playing)
        |> assign(:timer_object, timer_object)
        |> assign(:current_user, _session["user"])
        |> assign(:user_leaderboard_data, user_leaderboard_data)
        |> assign(:user_total_point, user_total_point)
        |> assign(:options, options)
        |> assign(:is_question_showing, is_question_showing)
        |> assign(:is_leaderboard_calculating, false)
        |> assign(:is_leaderboard_is_ready, is_leaderboard_ready)
        |> assign(:question, question)
        |> assign(:countdown, countdown)
        |> assign(:user_selected_option, 0)
        |> assign(:users, %{})
        |> assign(:vote_changeset, changeset_verify)
        |> assign(:is_form_valid, false)
        |> assign(:has_voted, has_voted)
        |> assign(:online_users, online_users)
        |> assign(:leaderboard_data, leaderboard_data)
        |> assign(:total_questions_count, total_questions_count)
        |> assign(:expanded, false)
        |> assign(:page_title, "مسابقه در حال اجرا")
#        |> handle_joins(Presence.list(@presence))
      }
    else
      {
        :ok,
        redirect(socket, to: "/")
      }
    end

  end

  def handle_event("vote_changeset", %{"answer_id" => answer_id}, socket) do
      if answer_id do
        {
          :noreply,
          socket
          |> assign(:user_selected_option, answer_id)
          |> assign(:is_form_valid, true)
        }
      else
        {
          :noreply,
          socket
          |> assign(:user_selected_option, answer_id)
        }
      end

  end


  def handle_info(:tick, socket) do
    if socket.assigns.countdown - 1 == 0 do
      :timer.cancel(socket.assigns.timer_object)
      {
        :noreply,
        socket
        |> assign(:countdown, 0)
      }
    else
      {:noreply, assign(socket, :countdown, socket.assigns.countdown - 1)}
    end
  end

  @impl true
  def handle_info({:game_started, message}, socket) do
    {
      :noreply,
      socket
      |> assign(:is_playing, true)
      |> assign(:user_can_attend_in_play_page, true)
      |> assign(:user_total_point, 0)
    }
  end

  @impl true
  def handle_info({:new_question_showed, message}, socket) do
    total_questions_count = Mafia.Utility.parsInt(Mafia.Redis.get_by_key!("#{Application.get_env(:mafia, :product_name)}_total_questions_count"))
    if socket.assigns[:timer_object] do
      :timer.cancel(socket.assigns.timer_object)
    end
    {:ok, timer} = :timer.send_interval(1000, self(), :tick)
    {
      :noreply,
      socket
      |> assign(:is_question_showing, true)
      |> assign(:question, message.question)
      |> assign(:options, message.options)
      |> assign(:timer_object, timer)
      |> assign(:countdown, message.question.answer_time)
      |> assign(:total_questions_count, total_questions_count)
      |> assign(:user_selected_option, 0)
      |> assign(:has_voted, false)
    }
  end

  @impl true
  def handle_info({:question_timeout, message}, socket) do
    if socket.assigns[:timer_object] do
      :timer.cancel(socket.assigns.timer_object)
    end
    {
      :noreply,
      socket
      |> assign(:is_question_showing, false)
      |> assign(:question, %{})
      |> assign(:options, [])
      |> assign(:countdown, 0)
    }
  end


  @impl true
  def handle_info({:game_ended, message}, socket) do
    if socket.assigns[:timer_object] do
      :timer.cancel(socket.assigns.timer_object)
    end
    {
      :noreply,
      socket
      |> assign(:is_playing, false)
      |> assign(:is_question_showing, false)
      |> assign(:countdown, 0)
    }
  end

#
#  @impl true
#  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
#    {
#      :noreply,
#      socket
#      |> handle_leaves(diff.leaves)
#      |> handle_joins(diff.joins)
#    }
#  end

#  defp handle_joins(socket, joins) do
#    Mafia.Game.broadcast(socket.assigns.current_user, :online_user_updated)
#    Enum.reduce(
#      joins,
#      socket,
#      fn {user, %{metas: [meta | _]}}, socket ->
#        assign(socket, :users, Map.put(socket.assigns.users, user, meta))
#      end
#    )
#  end

#  defp handle_leaves(socket, leaves) do
#    Mafia.Game.broadcast(socket.assigns.current_user, :online_user_updated)
#    Enum.reduce(
#      leaves,
#      socket,
#      fn {user, _}, socket ->
#        assign(socket, :users, Map.delete(socket.assigns.users, user))
#      end
#    )
#  end

#  @impl true
#  def handle_info({:online_user_updated, message}, socket) do
#    online_users = length(Map.keys(socket.assigns.users))
#    Mafia.Redis.set_by_key("online_users", online_users)
#    {
#      :noreply,
#      socket
#      |> assign(:online_users, online_users)
#    }
#  end


  @impl true
  def handle_event("vote", %{"answer_id" => option_id}, socket) do
    user_redis_key = "#{Application.get_env(:mafia, :product_name)}_statistics-#{to_string(socket.assigns.question.session_id)}-#{socket.assigns.current_user.id}"
    option_id = Mafia.Utility.parsInt(option_id)
    now_date = to_string(DateTime.utc_now() |> DateTime.to_unix(:millisecond))
    correct_option_id = Mafia.Utility.parsInt(Mafia.Redis.get_by_key!("#{Application.get_env(:mafia, :product_name)}_correct_option_id"))
    current_question_id =  Mafia.Utility.parsInt(Mafia.Redis.get_by_key!("#{Application.get_env(:mafia, :product_name)}_current_question_id"))
    point_gained = case option_id == correct_option_id do
      true ->
        Mafia.Utility.parsInt(Mafia.Redis.get_by_key!("#{Application.get_env(:mafia, :product_name)}_correct_option_point"))
      _ ->
        0
    end
    user_statistics = case Mafia.Redis.get_by_key(user_redis_key) do
      {:ok, nil} ->
        user_statistics = %{user_mobile: socket.assigns.current_user.mobile ,session_id: socket.assigns.question.session_id, user_id: socket.assigns.current_user.id, total_point: point_gained, votes: [%{question_id: socket.assigns.question.id, voted_for: option_id, point_gained: point_gained}]}
        done_question_key = "#{Application.get_env(:mafia, :product_name)}_voted-#{to_string(socket.assigns.question.session_id)}-#{socket.assigns.current_user.id}-#{to_string(current_question_id)}"
        Mafia.Redis.set_by_key(done_question_key, now_date)
        {:ok, encoded_user_statistics} = Jason.encode(user_statistics)
        Mafia.Redis.set_by_key(user_redis_key, encoded_user_statistics)
        {
          :noreply,
          socket
          |> assign(:has_voted, true)
          |> assign(:user_total_point, point_gained)
        }
      {:ok, value} ->
        {:ok, user_statistics} = Jason.decode(value, [{:keys, :atoms}])
        done_question_key = "#{Application.get_env(:mafia, :product_name)}_voted-#{to_string(socket.assigns.question.session_id)}-#{socket.assigns.current_user.id}-#{to_string(current_question_id)}"
        case Mafia.Redis.get_by_key!(done_question_key) do
          nil ->

            new_vote = %{question_id: socket.assigns.question.id, voted_for: option_id, point_gained: point_gained}
            done_question_key = "#{Application.get_env(:mafia, :product_name)}_voted-#{to_string(socket.assigns.question.session_id)}-#{socket.assigns.current_user.id}-#{to_string(current_question_id)}"
            Mafia.Redis.set_by_key(done_question_key, now_date)
            new_total_point = user_statistics.total_point + point_gained
            user_statistics = Map.put(user_statistics, :total_point, new_total_point)
            user_statistics = Map.put(user_statistics, :votes, user_statistics.votes ++ [new_vote])
            {:ok, encoded_user_statistics} = Jason.encode(user_statistics)
            Mafia.Redis.set_by_key(user_redis_key, encoded_user_statistics)
            {
              :noreply,
              socket
              |> assign(:has_voted, true)
              |> assign(:user_total_point, new_total_point)
            }
          _ ->
            {
              :noreply,
              socket
              |> assign(:has_voted, true)
              |> put_flash(:error, "شما قبلا رای دادید")
            }
        end
    end
  end

  @impl true
  def handle_event("toggle", _value, socket) do
    {:noreply, assign(socket, :expanded, !socket.assigns.expanded)}
  end

  @impl true
  def handle_info({:leaderboard_calculating, message}, socket) do
    IO.inspect(message.message)
    {
      :noreply,
      socket
      |> assign(:is_leaderboard_calculating, true)
    }
  end

  @impl true
  def handle_info({:leaderboard_is_ready, message}, socket) do
#    IO.inspect "=-=-=-=-=-=-=-"
#    IO.inspect socket.assigns.question
#    IO.inspect "=-=-=-=-=-=-=-"
    user_data = Mafia.Redis.get_by_key!("#{Application.get_env(:mafia, :product_name)}_statistics-#{socket.assigns.question.session_id}-#{socket.assigns.current_user.id}")
    {
      :noreply,
      socket
      |> assign(:is_leaderboard_calculating, false)
      |> assign(:is_leaderboard_is_ready, true)
      |> assign(:leaderboard_data, message)
      |> assign(:user_leaderboard_data, user_data)
    }
  end


  @impl true
  def handle_info({:countdown_updated, message}, socket) do
    {
      :noreply,
      socket
      |> assign(:countdown, message.current_time)
    }
  end

  @impl true
  def handle_info({:leaderboard_process_done, message}, socket) do
    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_info({:leaderboard_status_changed, message}, socket) do
    {
      :noreply,
      socket
    }
  end


  @impl true
  def handle_info({:refresh_game_page, message}, socket) do
    {
      :noreply,
      redirect(socket, to: "/game/play")
    }
  end

end
