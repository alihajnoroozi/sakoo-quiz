defmodule MafiaWeb.ContestLive.Performance do
  use MafiaWeb, :live_view
  require Logger

  @impl true
  def mount(%{"session_id" => session_id}, _session, socket) do

    if connected?(socket) do
      Mafia.Game.subscribe()
    end
    [current_game_id, questions] = case (Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_current_game_id")) do
      {:ok, nil} ->
        [nil, []]
      {:ok, value} ->
        questions = Mafia.Game.list_question(session_id)
        Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_total_questions_count", Enum.count(questions))
        [Mafia.Utility.parsInt(value), questions]
      _ ->
        [nil, []]
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

    current_question_id = case (Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_current_question_id")) do
      {:ok, nil} ->
        nil
      {:ok, ""} ->
        nil
      {:ok, value} ->
        Mafia.Utility.parsInt(value)
      _ ->
        nil
    end

    online_users = case Mafia.Redis.get_key_list_by_patters("#{Application.get_env(:mafia, :product_name)}_online_users_#{session_id}_*") do
      {:ok, nil} ->
        0
      {:ok, value} ->
        Enum.count(value)
    end

    [countdown, timer_object] = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_countdown_status") do
      {:ok, nil} ->
        [0, nil]
      {:ok, value} ->
        {:ok, timer} = :timer.send_interval(1000, self(), :tick)
        [Mafia.Utility.parsInt(value) - 1, timer]
      _ ->
        [0, nil]
    end

    is_leaderboard_ready = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_is_leaderboard_ready_#{session_id}") do
      {:ok, nil} ->
        false
      {:ok, "0"} ->
        false
      {:ok, "1"} ->
        true
      _ ->
        false
    end


    leaderboard_data = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_leaderboard_top_20_#{session_id}") do
      {:ok, nil} ->
        []
      {:ok, value} ->
        {:ok, result} = Jason.decode(value, [{:keys, :atoms}])
        result
      _ ->
        []
    end

    is_total_rank_calculated = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_is_total_rank_calculated_#{session_id}") do
      {:ok, nil} ->
        false
      {:ok, "0"} ->
        false
      {:ok, "1"} ->
        true
      _ ->
        false
    end

    should_show_calculate_leaderboard_ranks = case Mafia.Redis.get_by_key("#{Application.get_env(:mafia, :product_name)}_should_show_calculate_leaderboard_ranks_#{session_id}") do
      {:ok, nil} ->
        true
      {:ok, "0"} ->
        true
      {:ok, "1"} ->
        false
      _ ->
        true
    end

#    IO.inspect Mafia.Redis.get_by_key("is_total_rank_calculated_#{session_id}")

#    IO.inspect is_total_rank_calculated

    {
      :ok,
      socket
      |> assign(:is_playing, is_playing)
      |> assign(:session_id, session_id)
      |> assign(:countdown, countdown)
      |> assign(:timer_object, timer_object)
      |> assign(:status_message, nil)
      |> assign(:online_users, online_users)
      |> assign(:current_question_id, current_question_id)
      |> assign(:is_leaderboard_is_ready, is_leaderboard_ready)
      |> assign(:current_game_id, current_game_id)
      |> assign(:leaderboard_data, leaderboard_data)
      |> assign(:questions, questions)
      |> assign(:is_total_rank_calculated, is_total_rank_calculated)
      |> assign(:should_show_add_to_db_button, is_total_rank_calculated)
      |> assign(:should_show_calculate_leaderboard_ranks, should_show_calculate_leaderboard_ranks)
    }


  end

  @impl true
  def handle_event("end_game", %{"sessionid" => session_id}, socket) do
    session = Mafia.Game.get_session!(session_id)
    Mafia.Game.broadcast(session, :game_ended)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_total_questions_count", 0)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_is_leaderboard_calculating", 0)
    cancel_timer(socket)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_is_playing", 0)
    {
      :noreply,
      socket
      |> assign(:is_playing, false)
    }
  end


  @impl true
  def handle_event("refresh_game_page", _params, socket) do
    Mafia.Game.broadcast(%{}, :refresh_game_page)
    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_info({:leaderboard_calculating, message}, socket) do
#    IO.inspect(message.message)
    IO.inspect "شو کرده"
    Mafia.Redis.set_by_key("should_show_calculate_leaderboard_ranks", 0)
    {
      :noreply,
      socket
      |> assign(:status_message, message.message)
      |> assign(:should_show_calculate_leaderboard_ranks, false)
    }
  end

  @impl true
  def handle_info({:leaderboard_is_ready, message}, socket) do

    {
      :noreply,
      socket
      |> assign(:status_message, "در حال ذخیره سازی در دیبابیس")
      |> assign(:is_leaderboard_ready, true)
      |> assign(:leaderboard_data, message)
    }
  end


  @impl true
  def handle_info({:leaderboard_process_done, message}, socket) do
    {
      :noreply,
      socket
      |> assign(:status_message, "ذخیره سازی رای ها در پایگاه داده به اتمام رسید، پس از اتمام محاسبه لیدر بورد انجام شود")
    }
  end

  @impl true
  def handle_info({:leaderboard_status_changed, message}, socket) do
    {
      :noreply,
      socket
      |> assign(:status_message, message)
    }
  end

  @impl true
  def handle_event("calculate_leaderboard", %{"sessionid" => session_id}, socket) do
    Mafia.Game.broadcast(%{message: "در حال محاسبه لیدر بورد"}, :leaderboard_calculating)
    {:ok, key_list} = Mafia.Redis.get_key_list_by_patters("#{Application.get_env(:mafia, :product_name)}_statistics-#{session_id}-")
    user_data_list = for user_data <- key_list do
      {:ok, string_user_statistics} = Jason.decode(Mafia.Redis.get_by_key!(user_data), [{:keys, :atoms}])
      string_user_statistics
    end
    #    user_data_list = Enum.sort_by(user_data_list, &(&1.total_point), :desc)
    user_data_list = calculate_rank!(user_data_list)
    user_data_list = Enum.sort_by(user_data_list, &(&1.rank))
    top_20 = Enum.take(user_data_list, 20)
    for user <- user_data_list do
      redis_key = "#{Application.get_env(:mafia, :product_name)}_statistics-#{session_id}-#{user.user_id}"
      {:ok, encoded_user_with_rank} = Jason.encode(user)
      Mafia.Redis.set_by_key(redis_key, encoded_user_with_rank)
    end
    Mafia.Game.broadcast(top_20, :leaderboard_is_ready)
    {:ok, json_encoded_top_20} = Jason.encode(top_20)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_leaderboard_top_20_#{session_id}", json_encoded_top_20)
    session = Mafia.Game.get_session!(session_id)
    Mafia.Game.update_session(session, %{total_vote_count: Enum.count(key_list)})
    for user_data <- user_data_list do
      for vote <- user_data.votes do
        Mafia.Accounts.create_user_vote(
          %{
            user_id: user_data.user_id,
            question_id: vote.question_id,
            answer_id: vote.voted_for,
            session_id: session_id,
            point_gained: vote.point_gained
          }
        )
        voted_key = "#{Application.get_env(:mafia, :product_name)}_voted-#{session_id}-#{to_string(user_data.user_id)}-#{to_string(vote.question_id)}"
        Mafia.Redis.del_by_key(voted_key)
      end
#      Mafia.Game.broadcast("رای کاربران در دیتابیس ذخیره شد، در حال واریز رنک ها به دیتابیس ...", :leaderboard_status_changed)

      Mafia.Accounts.create_user_session_total_point(
        %{
          rank: user_data.rank,
          user_id: user_data.user_id,
          session_id: user_data.session_id,
          total_point: user_data.total_point
        }
      )
      case Mafia.Accounts.get_user_total_point_by_user_id!(user_data.user_id) do
        nil ->
          Mafia.Accounts.create_user_total_point(
            %{user_id: user_data.user_id, total_point: user_data.total_point}
          )
        user_total_point = %{} ->
          new_total_point = user_total_point.total_point + user_data.total_point
          Mafia.Accounts.update_user_total_point(user_total_point, %{total_point: new_total_point})
      end
    end
    Mafia.Game.broadcast(%{}, :leaderboard_process_done)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_is_leaderboard_ready_#{session_id}", "1")
    {
      :noreply,
      socket
      |> assign(:should_show_add_to_db_button, true)
    }
  end

  @impl true
  def handle_event("calculate_total_leaderboard_rank", %{"sessionid" => session_id}, socket) do
    Mafia.Game.broadcast("در حال محاسبه و به روز رسانی لیدر بورد کلی", :leaderboard_status_changed)
    users_data = Mafia.Accounts.list_user_total_point()
    users_data = sort_with_rank!(users_data)
    calculated_user_ranks = calculate_rank!(users_data)
    users_data
    |> Enum.with_index
    |> Enum.each(fn({x, i}) ->
      Mafia.Accounts.update_user_total_point(x, %{rank: Enum.at(calculated_user_ranks, i).rank})
    end)
    session = Mafia.Game.get_session!(session_id)
    Mafia.Game.update_session(session, %{is_closed: true})
    Mafia.Game.broadcast("لیدر برد کلی به روز رسانی شد", :leaderboard_status_changed)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_is_total_rank_calculated_#{session_id}", "1")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_total_leaderboard_ranks")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_sessions_list")
    {
      :noreply,
      socket
      |> assign(:should_show_add_to_db_button, true)
    }
  end

  @impl true
  def handle_event("show_question", %{"questionid" => question_id}, socket) do
    # ----- Handle timer and remove timer conflict
    cancel_timer(socket)
    {:ok, timer} = :timer.send_interval(1000, self(), :tick)
    # ----- Get question and it's options
    question = Mafia.Game.get_question!(question_id)
    options = Mafia.Game.list_answer(question_id)
    # ----- Cast to standard objects and make it string
    casted_question = Mafia.Game.Question.user_cast(question)
    casted_options = Mafia.Game.Answer.user_cast_list(options)
    {:ok, string_question} = Jason.encode(casted_question)
    {:ok, string_options} = Jason.encode(casted_options)
    # ----- Redis Sets
    correct_answer = Mafia.Game.get_correct_answer!(options)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_correct_option_id", List.first(correct_answer).id)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_correct_option_point", question.point)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_current_question_id", question_id)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_current_question", string_question)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_current_options", string_options)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_is_question_showing", 1)
    # ----- Broadcast new_question_showed event
    Mafia.Game.broadcast(%{question: casted_question, options: casted_options}, :new_question_showed)
    {
      :noreply,
      socket
      |> assign(:current_question_id, question.id)
      |> assign(:timer_object, timer)
      |> assign(:countdown, question.answer_time)
    }
  end


  def handle_info(:tick, socket) do
    if socket.assigns.countdown - 1 == 0 do
      cancel_timer(socket)
      Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_countdown_status", socket.assigns.countdown)
      #      Mafia.Game.broadcast(%{current_time: 0}, :countdown_updated)
      hide_question()
      {
        :noreply,
        socket
        |> assign(:current_question_id, nil)
        |> assign(:countdown, 0)
      }
    else
      Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_countdown_status", socket.assigns.countdown)
      #      Mafia.Game.broadcast(%{current_time: socket.assigns.countdown - 1}, :countdown_updated)
      {:noreply, assign(socket, :countdown, socket.assigns.countdown - 1)}
    end
  end


  def handle_event("hide_question", %{"questionid" => question_id}, socket) do
    hide_question()
    cancel_timer(socket)
    {
      :noreply,
      socket
      |> assign(:current_question_id, nil)
      |> assign(:countdown, 0)
    }
  end

  defp hide_question do
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_current_question_id")
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_countdown_status", 0)
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_is_question_showing", 0)
    Mafia.Game.broadcast(%{}, :question_timeout)
  end


  defp cancel_timer(socket) do
    if socket.assigns[:timer_object] do
      :timer.cancel(socket.assigns.timer_object)
    end
  end

  @impl true
  def handle_info({:game_started, message}, socket) do
    questions = Mafia.Game.list_question(Mafia.Utility.parsInt(socket.assigns.session_id))
    {:noreply, update(socket, :questions, questions)}
  end

  @impl true
  def handle_info({:question_timeout, message}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:new_question_showed, message}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:game_ended, message}, socket) do
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_correct_option_id")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_correct_option_point")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_current_question_id")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_current_question")
    Mafia.Redis.del_by_key("#{Application.get_env(:mafia, :product_name)}_current_options")
    Mafia.Redis.set_by_key("#{Application.get_env(:mafia, :product_name)}_is_question_showing", 0)
    {
      :noreply,
      socket
      |> assign(:questions, [])
    }
  end

  @impl true
  def handle_info({:online_user_updated, message}, socket) do
#    {:ok, online_users} = Mafia.Redis.get_by_key("online_users")
    {
      :noreply,
      socket
#      |> assign(:online_users, online_users)
    }
  end

  @impl true
  def handle_info({:countdown_updated, message}, socket) do
    {
      :noreply,
      socket
    }
  end


  defp calculate_rank!(user_list) do
    user_list
    |> Enum.group_by(fn x -> x.total_point end)
    |> Enum.sort_by(&(&1), :desc)
    |> Enum.with_index
    |> Enum.into([], fn {{point, users}, rank} -> Enum.map(users, fn user -> Map.put(user, :rank, rank + 1) end) end)
    |> List.flatten()
  end


  defp sort_with_rank!(user_list) do
    user_list
    |> Enum.group_by(fn x -> x.total_point end)
    |> Enum.sort_by(&(&1), :desc)
    |> Enum.with_index
    |> Enum.into([], fn {{point, users}, rank} -> Enum.map(users, fn user -> user end) end)
    |> List.flatten()
  end

  @impl true
  def handle_info({:refresh_game_page, message}, socket) do
    IO.inspect("Game Page refreshed")
    {
      :noreply,
      socket
      |> assign(:status_message, "صفحه کاربران رفرش شد")
    }
  end

end

