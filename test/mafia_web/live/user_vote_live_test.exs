defmodule MafiaWeb.UserVoteLiveTest do
  use MafiaWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Mafia.Accounts

  @create_attrs %{user_id: "some user_id", vote_id: "some vote_id"}
  @update_attrs %{user_id: "some updated user_id", vote_id: "some updated vote_id"}
  @invalid_attrs %{user_id: nil, vote_id: nil}

  defp fixture(:user_vote) do
    {:ok, user_vote} = Accounts.create_user_vote(@create_attrs)
    user_vote
  end

  defp create_user_vote(_) do
    user_vote = fixture(:user_vote)
    %{user_vote: user_vote}
  end

  describe "Index" do
    setup [:create_user_vote]

    test "lists all user_vote", %{conn: conn, user_vote: user_vote} do
      {:ok, _index_live, html} = live(conn, Routes.user_vote_index_path(conn, :index))

      assert html =~ "Listing User vote"
      assert html =~ user_vote.user_id
    end

    test "saves new user_vote", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.user_vote_index_path(conn, :index))

      assert index_live |> element("a", "New User vote") |> render_click() =~
               "New User vote"

      assert_patch(index_live, Routes.user_vote_index_path(conn, :new))

      assert index_live
             |> form("#user_vote-form", user_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#user_vote-form", user_vote: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_vote_index_path(conn, :index))

      assert html =~ "User vote created successfully"
      assert html =~ "some user_id"
    end

    test "updates user_vote in listing", %{conn: conn, user_vote: user_vote} do
      {:ok, index_live, _html} = live(conn, Routes.user_vote_index_path(conn, :index))

      assert index_live |> element("#user_vote-#{user_vote.id} a", "Edit") |> render_click() =~
               "Edit User vote"

      assert_patch(index_live, Routes.user_vote_index_path(conn, :edit, user_vote))

      assert index_live
             |> form("#user_vote-form", user_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#user_vote-form", user_vote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_vote_index_path(conn, :index))

      assert html =~ "User vote updated successfully"
      assert html =~ "some updated user_id"
    end

    test "deletes user_vote in listing", %{conn: conn, user_vote: user_vote} do
      {:ok, index_live, _html} = live(conn, Routes.user_vote_index_path(conn, :index))

      assert index_live |> element("#user_vote-#{user_vote.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_vote-#{user_vote.id}")
    end
  end

  describe "Show" do
    setup [:create_user_vote]

    test "displays user_vote", %{conn: conn, user_vote: user_vote} do
      {:ok, _show_live, html} = live(conn, Routes.user_vote_show_path(conn, :show, user_vote))

      assert html =~ "Show User vote"
      assert html =~ user_vote.user_id
    end

    test "updates user_vote within modal", %{conn: conn, user_vote: user_vote} do
      {:ok, show_live, _html} = live(conn, Routes.user_vote_show_path(conn, :show, user_vote))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User vote"

      assert_patch(show_live, Routes.user_vote_show_path(conn, :edit, user_vote))

      assert show_live
             |> form("#user_vote-form", user_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#user_vote-form", user_vote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.user_vote_show_path(conn, :show, user_vote))

      assert html =~ "User vote updated successfully"
      assert html =~ "some updated user_id"
    end
  end
end
