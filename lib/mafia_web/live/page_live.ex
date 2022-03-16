defmodule MafiaWeb.PageLive do
  use MafiaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Mafia.Game.subscribe()
    end
    is_playing = case (Mafia.Redis.get_by_key("is_playing")) do
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
    {:ok, assign(socket, query: "", results: %{})
      |> assign(:current_user, _session["user"])
      |> assign(:is_playing, is_playing)
      |> assign(:expanded, false)
    }
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not MafiaWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end

  @impl true
  def handle_info({:game_started, message}, socket) do
    {
      :noreply,
      socket
      |> assign(:is_playing, true)
    }
  end

  @impl true
  def handle_info({:game_ended, message}, socket) do
    {
      :noreply,
      socket
      |> assign(:is_playing, false)
    }
  end

  @impl true
  def handle_info({:leaderboard_calculating, message}, socket) do
    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_info({:leaderboard_is_ready, message}, socket) do
    user_data = Mafia.Redis.get_by_key!("statistics-#{socket.assigns.question.session_id}-#{socket.assigns.current_user.id}")
    {
      :noreply,
      socket
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
  def handle_info({:countdown_updated, message}, socket) do
    {
      :noreply,
      socket
    }
  end

  @impl true
  def handle_info({:online_user_updated, message}, socket) do
    {:ok, online_users} = Mafia.Redis.get_by_key("online_users")
    {
      :noreply,
      socket
    }
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
      socket
    }
  end

  @impl true
  def handle_event("toggle", _value, socket) do
    {:noreply, assign(socket, :expanded, !socket.assigns.expanded)}
  end
end
