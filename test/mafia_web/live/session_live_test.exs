defmodule MafiaWeb.SessionLiveTest do
  use MafiaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Mafia.Game

  @create_attrs %{description: "some description", image_path: "some image_path", is_closed: true, is_published: true, title: "some title", total_vote_count: 42, video_path: "some video_path"}
  @update_attrs %{description: "some updated description", image_path: "some updated image_path", is_closed: false, is_published: false, title: "some updated title", total_vote_count: 43, video_path: "some updated video_path"}
  @invalid_attrs %{description: nil, image_path: nil, is_closed: nil, is_published: nil, title: nil, total_vote_count: nil, video_path: nil}

  defp fixture(:session) do
    {:ok, session} = Game.create_session(@create_attrs)
    session
  end

  defp create_session(_) do
    session = fixture(:session)
    %{session: session}
  end

  describe "Index" do
    setup [:create_session]

    test "lists all session", %{conn: conn, session: session} do
      {:ok, _index_live, html} = live(conn, Routes.session_index_path(conn, :index))

      assert html =~ "Listing Session"
      assert html =~ session.description
    end

    test "saves new session", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.session_index_path(conn, :index))

      assert index_live |> element("a", "New Session") |> render_click() =~
               "New Session"

      assert_patch(index_live, Routes.session_index_path(conn, :new))

      assert index_live
             |> form("#session-form", session: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#session-form", session: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.session_index_path(conn, :index))

      assert html =~ "Session created successfully"
      assert html =~ "some description"
    end

    test "updates session in listing", %{conn: conn, session: session} do
      {:ok, index_live, _html} = live(conn, Routes.session_index_path(conn, :index))

      assert index_live |> element("#session-#{session.id} a", "Edit") |> render_click() =~
               "Edit Session"

      assert_patch(index_live, Routes.session_index_path(conn, :edit, session))

      assert index_live
             |> form("#session-form", session: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#session-form", session: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.session_index_path(conn, :index))

      assert html =~ "Session updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes session in listing", %{conn: conn, session: session} do
      {:ok, index_live, _html} = live(conn, Routes.session_index_path(conn, :index))

      assert index_live |> element("#session-#{session.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#session-#{session.id}")
    end
  end

  describe "Show" do
    setup [:create_session]

    test "displays session", %{conn: conn, session: session} do
      {:ok, _show_live, html} = live(conn, Routes.session_show_path(conn, :show, session))

      assert html =~ "Show Session"
      assert html =~ session.description
    end

    test "updates session within modal", %{conn: conn, session: session} do
      {:ok, show_live, _html} = live(conn, Routes.session_show_path(conn, :show, session))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Session"

      assert_patch(show_live, Routes.session_show_path(conn, :edit, session))

      assert show_live
             |> form("#session-form", session: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#session-form", session: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.session_show_path(conn, :show, session))

      assert html =~ "Session updated successfully"
      assert html =~ "some updated description"
    end
  end
end
