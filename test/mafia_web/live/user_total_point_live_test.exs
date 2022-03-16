defmodule MafiaWeb.UserTotalPointLiveTest do
  use MafiaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Mafia.Accounts

  @create_attrs %{total_point: 42, user_id: "some user_id"}
  @update_attrs %{total_point: 43, user_id: "some updated user_id"}
  @invalid_attrs %{total_point: nil, user_id: nil}

  defp fixture(:user_total_point) do
    {:ok, user_total_point} = Accounts.create_user_total_point(@create_attrs)
    user_total_point
  end

  defp create_user_total_point(_) do
    user_total_point = fixture(:user_total_point)
    %{user_total_point: user_total_point}
  end

  describe "Index" do
    setup [:create_user_total_point]

    test "lists all user_total_point", %{conn: conn, user_total_point: user_total_point} do
      {:ok, _index_live, html} = live(conn, Routes.user_total_point_index_path(conn, :index))

      assert html =~ "Listing User total point"
      assert html =~ user_total_point.user_id
    end

    test "saves new user_total_point", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.user_total_point_index_path(conn, :index))

      assert index_live |> element("a", "New User total point") |> render_click() =~
               "New User total point"

      assert_patch(index_live, Routes.user_total_point_index_path(conn, :new))

      assert index_live
             |> form("#user_total_point-form", user_total_point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#user_total_point-form", user_total_point: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_total_point_index_path(conn, :index))

      assert html =~ "User total point created successfully"
      assert html =~ "some user_id"
    end

    test "updates user_total_point in listing", %{conn: conn, user_total_point: user_total_point} do
      {:ok, index_live, _html} = live(conn, Routes.user_total_point_index_path(conn, :index))

      assert index_live |> element("#user_total_point-#{user_total_point.id} a", "Edit") |> render_click() =~
               "Edit User total point"

      assert_patch(index_live, Routes.user_total_point_index_path(conn, :edit, user_total_point))

      assert index_live
             |> form("#user_total_point-form", user_total_point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#user_total_point-form", user_total_point: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_total_point_index_path(conn, :index))

      assert html =~ "User total point updated successfully"
      assert html =~ "some updated user_id"
    end

    test "deletes user_total_point in listing", %{conn: conn, user_total_point: user_total_point} do
      {:ok, index_live, _html} = live(conn, Routes.user_total_point_index_path(conn, :index))

      assert index_live |> element("#user_total_point-#{user_total_point.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_total_point-#{user_total_point.id}")
    end
  end

  describe "Show" do
    setup [:create_user_total_point]

    test "displays user_total_point", %{conn: conn, user_total_point: user_total_point} do
      {:ok, _show_live, html} = live(conn, Routes.user_total_point_show_path(conn, :show, user_total_point))

      assert html =~ "Show User total point"
      assert html =~ user_total_point.user_id
    end

    test "updates user_total_point within modal", %{conn: conn, user_total_point: user_total_point} do
      {:ok, show_live, _html} = live(conn, Routes.user_total_point_show_path(conn, :show, user_total_point))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User total point"

      assert_patch(show_live, Routes.user_total_point_show_path(conn, :edit, user_total_point))

      assert show_live
             |> form("#user_total_point-form", user_total_point: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#user_total_point-form", user_total_point: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_total_point_show_path(conn, :show, user_total_point))

      assert html =~ "User total point updated successfully"
      assert html =~ "some updated user_id"
    end
  end
end
