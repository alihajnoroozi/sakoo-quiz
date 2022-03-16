defmodule MafiaWeb.LeaderboardLive.Total do
  use MafiaWeb, :live_view
  require Logger
  alias Mafia.Presence

  @presence "mafia:presence"
  @impl true
  def mount(_params, _session, socket) do
    user_ranks = case Mafia.Redis.get_by_key("total_leaderboard_ranks") do
      {:ok, nil} ->
        ranks = get_users_ranks()
        {:ok, string_ranks} = Jason.encode(ranks)
        Mafia.Redis.set_by_key("total_leaderboard_ranks", string_ranks)
        ranks
      {:ok, value} ->
        {:ok, result} = Jason.decode(value, [{:keys, :atoms}])
        result
      _ ->
        ranks = get_users_ranks()
        {:ok, string_ranks} = Jason.encode(ranks)
        Mafia.Redis.set_by_key("total_leaderboard_ranks", string_ranks)
        ranks
    end

    [total_point, rank] = case  result = Mafia.Accounts.get_user_latest_total_point!(_session["user"].id) do
      nil ->
        [0,0]
      _ ->
        [result.total_point, result.rank]
      end

    sessions_list = case Mafia.Redis.get_by_key("sessions_list") do
      {:ok, nil } ->
          get_sessions_list_from_database()
      {:ok, value} ->
          { :ok, decoded_sessions } = Jason.decode(value, [{:keys, :atoms}])
          decoded_sessions
        _ ->
          get_sessions_list_from_database()
    end

    {
      :ok,
      socket
      |> assign(:user_ranks, user_ranks)
      |> assign(:user_leaderboard_data, %{total_point: total_point, rank: rank})
      |> assign(:current_user, _session["user"])
      |> assign(:sessions_list, sessions_list)
      |> assign(:sessions_leaderboard_data, [])
      |> assign(:current_user_session_total_point, 0)
      |> assign(:current_user_session_rank, 0)
      |> assign(:expanded, false)
      |> assign(:page_title, "لیدربرد مسابقه مافیا")
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

  defp get_users_ranks() do
    total_points = Mafia.Accounts.get_users_total_points!(1)
    calculate_rank!(total_points)
  end

  @impl true
  def handle_event("get_specific_session_data", %{"session_id" => session_id}, socket) do
#    IO.inspect session_id
    session_data = get_specific_session_data(session_id)
    [current_user_session_rank, current_user_total_point] = get_user_session_data!(session_id, socket.assigns.current_user.id)
#    IO.inspect "=============="
#    IO.inspect user_data
    {
      :noreply,
      socket
      |> assign(:sessions_leaderboard_data, session_data)
      |> assign(:current_user_session_total_point, current_user_total_point)
      |> assign(:current_user_session_rank, current_user_session_rank)
    }
  end


  defp get_sessions_list_from_database() do
    sessions = Mafia.Game.list_session_published()
    { :ok, encoded_sessions } = Jason.encode(Mafia.Game.Session.session_cast(sessions))
    Mafia.Redis.set_by_key("sessions_list", encoded_sessions)
    sessions
  end

  defp get_specific_session_data(session_id) do
    Mafia.Accounts.list_user_session_total_point_by_session_id_sorted_by_rank(Mafia.Utility.parsInt(session_id))
  end

  defp get_user_session_data!(session_id, user_id) do
    case Mafia.Accounts.get_user_session_total_point_by_session_id!(session_id, user_id) do
      value = %Mafia.Accounts.UserSessionTotalPoint{} ->
        [value.rank, value.total_point]
      nil ->
        [0, 0]

    end
  end

  @impl true
  def handle_event("toggle", _value, socket) do
    {:noreply, assign(socket, :expanded, !socket.assigns.expanded)}
  end
end
