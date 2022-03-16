defmodule MafiaWeb.UserSessionTotalPointLiveTest do
  use MafiaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Mafia.Accounts

  @create_attrs %{session_id: "some session_id", total_point: 42, user_id: "some user_id"}
  @update_attrs %{session_id: "some updated session_id", total_point: 43, user_id: "some updated user_id"}
  @invalid_attrs %{session_id: nil, total_point: nil, user_id: nil}

  defp fixture(:user_session_total_point) do
    {:ok, user_session_total_point} = Accounts.create_user_session_total_point(@create_attrs)
    user_session_total_point
  end

  defp create_user_session_total_point(_) do
    user_session_total_point = fixture(:user_session_total_point)
    %{user_session_total_point: user_session_total_point}
  end

  describe "Index" do
    setup [:create_user_session_total_point]

    test "lists all user_session_total_point", %{conn: conn, user_session_total_point: user_session_total_point} do
      {:ok, _index_live, html} = live(conn, Routes.user_session_total_point_index_path(conn, :index))

      assert html =~ "Listing User session total point"
      assert html =~ user_session_total_point.session_id
    end

    test "saves new user_session_total_point", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.user_session_total_point_index_path(conn, :index))

      assert index_live |> element("a", "New User session total point") |> render_click() =~
               "New User session total point"

      assert_patch(index_live, Routes.user_session_total_point_index_path(conn, :new))

      assert index_live
             |> form("#user_session_total_point-form", user_session_total_point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#user_session_total_point-form", user_session_total_point: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_session_total_point_index_path(conn, :index))

      assert html =~ "User session total point created successfully"
      assert html =~ "some session_id"
    end

    test "updates user_session_total_point in listing", %{conn: conn, user_session_total_point: user_session_total_point} do
      {:ok, index_live, _html} = live(conn, Routes.user_session_total_point_index_path(conn, :index))

      assert index_live |> element("#user_session_total_point-#{user_session_total_point.id} a", "Edit") |> render_click() =~
               "Edit User session total point"

      assert_patch(index_live, Routes.user_session_total_point_index_path(conn, :edit, user_session_total_point))

      assert index_live
             |> form("#user_session_total_point-form", user_session_total_point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#user_session_total_point-form", user_session_total_point: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_session_total_point_index_path(conn, :index))

      assert html =~ "User session total point updated successfully"
      assert html =~ "some updated session_id"
    end

    test "deletes user_session_total_point in listing", %{conn: conn, user_session_total_point: user_session_total_point} do
      {:ok, index_live, _html} = live(conn, Routes.user_session_total_point_index_path(conn, :index))

      assert index_live |> element("#user_session_total_point-#{user_session_total_point.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_session_total_point-#{user_session_total_point.id}")
    end
  end

  describe "Show" do
    setup [:create_user_session_total_point]

    test "displays user_session_total_point", %{conn: conn, user_session_total_point: user_session_total_point} do
      {:ok, _show_live, html} = live(conn, Routes.user_session_total_point_show_path(conn, :show, user_session_total_point))

      assert html =~ "Show User session total point"
      assert html =~ user_session_total_point.session_id
    end

    test "updates user_session_total_point within modal", %{conn: conn, user_session_total_point: user_session_total_point} do
      {:ok, show_live, _html} = live(conn, Routes.user_session_total_point_show_path(conn, :show, user_session_total_point))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User session total point"

      assert_patch(show_live, Routes.user_session_total_point_show_path(conn, :edit, user_session_total_point))

      assert show_live
             |> form("#user_session_total_point-form", user_session_total_point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#user_session_total_point-form", user_session_total_point: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_session_total_point_show_path(conn, :show, user_session_total_point))

      assert html =~ "User session total point updated successfully"
      assert html =~ "some updated session_id"
    end
  end
end
