defmodule Mafia.AccountsTest do
  use Mafia.DataCase

  alias Mafia.Accounts

  describe "user" do
    alias Mafia.Accounts.User

    @valid_attrs %{is_admin: "some is_admin", mobile: "some mobile", name: "some name", username: "some username"}
    @update_attrs %{is_admin: "some updated is_admin", mobile: "some updated mobile", name: "some updated name", username: "some updated username"}
    @invalid_attrs %{is_admin: nil, mobile: nil, name: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_user/0 returns all user" do
      user = user_fixture()
      assert Accounts.list_user() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.is_admin == "some is_admin"
      assert user.mobile == "some mobile"
      assert user.name == "some name"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.is_admin == "some updated is_admin"
      assert user.mobile == "some updated mobile"
      assert user.name == "some updated name"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "user_vote" do
    alias Mafia.Accounts.UserVote

    @valid_attrs %{user_id: "some user_id", vote_id: "some vote_id"}
    @update_attrs %{user_id: "some updated user_id", vote_id: "some updated vote_id"}
    @invalid_attrs %{user_id: nil, vote_id: nil}

    def user_vote_fixture(attrs \\ %{}) do
      {:ok, user_vote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_vote()

      user_vote
    end

    test "list_user_vote/0 returns all user_vote" do
      user_vote = user_vote_fixture()
      assert Accounts.list_user_vote() == [user_vote]
    end

    test "get_user_vote!/1 returns the user_vote with given id" do
      user_vote = user_vote_fixture()
      assert Accounts.get_user_vote!(user_vote.id) == user_vote
    end

    test "create_user_vote/1 with valid data creates a user_vote" do
      assert {:ok, %UserVote{} = user_vote} = Accounts.create_user_vote(@valid_attrs)
      assert user_vote.user_id == "some user_id"
      assert user_vote.vote_id == "some vote_id"
    end

    test "create_user_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_vote(@invalid_attrs)
    end

    test "update_user_vote/2 with valid data updates the user_vote" do
      user_vote = user_vote_fixture()
      assert {:ok, %UserVote{} = user_vote} = Accounts.update_user_vote(user_vote, @update_attrs)
      assert user_vote.user_id == "some updated user_id"
      assert user_vote.vote_id == "some updated vote_id"
    end

    test "update_user_vote/2 with invalid data returns error changeset" do
      user_vote = user_vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_vote(user_vote, @invalid_attrs)
      assert user_vote == Accounts.get_user_vote!(user_vote.id)
    end

    test "delete_user_vote/1 deletes the user_vote" do
      user_vote = user_vote_fixture()
      assert {:ok, %UserVote{}} = Accounts.delete_user_vote(user_vote)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_vote!(user_vote.id) end
    end

    test "change_user_vote/1 returns a user_vote changeset" do
      user_vote = user_vote_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_vote(user_vote)
    end
  end

  describe "user_total_point" do
    alias Mafia.Accounts.UserTotalPoint

    @valid_attrs %{total_point: 42, user_id: "some user_id"}
    @update_attrs %{total_point: 43, user_id: "some updated user_id"}
    @invalid_attrs %{total_point: nil, user_id: nil}

    def user_total_point_fixture(attrs \\ %{}) do
      {:ok, user_total_point} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_total_point()

      user_total_point
    end

    test "list_user_total_point/0 returns all user_total_point" do
      user_total_point = user_total_point_fixture()
      assert Accounts.list_user_total_point() == [user_total_point]
    end

    test "get_user_total_point!/1 returns the user_total_point with given id" do
      user_total_point = user_total_point_fixture()
      assert Accounts.get_user_total_point!(user_total_point.id) == user_total_point
    end

    test "create_user_total_point/1 with valid data creates a user_total_point" do
      assert {:ok, %UserTotalPoint{} = user_total_point} = Accounts.create_user_total_point(@valid_attrs)
      assert user_total_point.total_point == 42
      assert user_total_point.user_id == "some user_id"
    end

    test "create_user_total_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_total_point(@invalid_attrs)
    end

    test "update_user_total_point/2 with valid data updates the user_total_point" do
      user_total_point = user_total_point_fixture()
      assert {:ok, %UserTotalPoint{} = user_total_point} = Accounts.update_user_total_point(user_total_point, @update_attrs)
      assert user_total_point.total_point == 43
      assert user_total_point.user_id == "some updated user_id"
    end

    test "update_user_total_point/2 with invalid data returns error changeset" do
      user_total_point = user_total_point_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_total_point(user_total_point, @invalid_attrs)
      assert user_total_point == Accounts.get_user_total_point!(user_total_point.id)
    end

    test "delete_user_total_point/1 deletes the user_total_point" do
      user_total_point = user_total_point_fixture()
      assert {:ok, %UserTotalPoint{}} = Accounts.delete_user_total_point(user_total_point)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_total_point!(user_total_point.id) end
    end

    test "change_user_total_point/1 returns a user_total_point changeset" do
      user_total_point = user_total_point_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_total_point(user_total_point)
    end
  end

  describe "user_session_total_point" do
    alias Mafia.Accounts.UserSessionTotalPoint

    @valid_attrs %{session_id: "some session_id", total_point: 42, user_id: "some user_id"}
    @update_attrs %{session_id: "some updated session_id", total_point: 43, user_id: "some updated user_id"}
    @invalid_attrs %{session_id: nil, total_point: nil, user_id: nil}

    def user_session_total_point_fixture(attrs \\ %{}) do
      {:ok, user_session_total_point} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user_session_total_point()

      user_session_total_point
    end

    test "list_user_session_total_point/0 returns all user_session_total_point" do
      user_session_total_point = user_session_total_point_fixture()
      assert Accounts.list_user_session_total_point() == [user_session_total_point]
    end

    test "get_user_session_total_point!/1 returns the user_session_total_point with given id" do
      user_session_total_point = user_session_total_point_fixture()
      assert Accounts.get_user_session_total_point!(user_session_total_point.id) == user_session_total_point
    end

    test "create_user_session_total_point/1 with valid data creates a user_session_total_point" do
      assert {:ok, %UserSessionTotalPoint{} = user_session_total_point} = Accounts.create_user_session_total_point(@valid_attrs)
      assert user_session_total_point.session_id == "some session_id"
      assert user_session_total_point.total_point == 42
      assert user_session_total_point.user_id == "some user_id"
    end

    test "create_user_session_total_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_session_total_point(@invalid_attrs)
    end

    test "update_user_session_total_point/2 with valid data updates the user_session_total_point" do
      user_session_total_point = user_session_total_point_fixture()
      assert {:ok, %UserSessionTotalPoint{} = user_session_total_point} = Accounts.update_user_session_total_point(user_session_total_point, @update_attrs)
      assert user_session_total_point.session_id == "some updated session_id"
      assert user_session_total_point.total_point == 43
      assert user_session_total_point.user_id == "some updated user_id"
    end

    test "update_user_session_total_point/2 with invalid data returns error changeset" do
      user_session_total_point = user_session_total_point_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_session_total_point(user_session_total_point, @invalid_attrs)
      assert user_session_total_point == Accounts.get_user_session_total_point!(user_session_total_point.id)
    end

    test "delete_user_session_total_point/1 deletes the user_session_total_point" do
      user_session_total_point = user_session_total_point_fixture()
      assert {:ok, %UserSessionTotalPoint{}} = Accounts.delete_user_session_total_point(user_session_total_point)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_session_total_point!(user_session_total_point.id) end
    end

    test "change_user_session_total_point/1 returns a user_session_total_point changeset" do
      user_session_total_point = user_session_total_point_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_session_total_point(user_session_total_point)
    end
  end
end
