defmodule Mafia.AccountTest do
  use Mafia.DataCase

  alias Mafia.Account

  describe "user_vote" do
    alias Mafia.Account.UserVote

    @valid_attrs %{user_id: "some user_id", vote_id: "some vote_id"}
    @update_attrs %{user_id: "some updated user_id", vote_id: "some updated vote_id"}
    @invalid_attrs %{user_id: nil, vote_id: nil}

    def user_vote_fixture(attrs \\ %{}) do
      {:ok, user_vote} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user_vote()

      user_vote
    end

    test "list_user_vote/0 returns all user_vote" do
      user_vote = user_vote_fixture()
      assert Account.list_user_vote() == [user_vote]
    end

    test "get_user_vote!/1 returns the user_vote with given id" do
      user_vote = user_vote_fixture()
      assert Account.get_user_vote!(user_vote.id) == user_vote
    end

    test "create_user_vote/1 with valid data creates a user_vote" do
      assert {:ok, %UserVote{} = user_vote} = Account.create_user_vote(@valid_attrs)
      assert user_vote.user_id == "some user_id"
      assert user_vote.vote_id == "some vote_id"
    end

    test "create_user_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user_vote(@invalid_attrs)
    end

    test "update_user_vote/2 with valid data updates the user_vote" do
      user_vote = user_vote_fixture()
      assert {:ok, %UserVote{} = user_vote} = Account.update_user_vote(user_vote, @update_attrs)
      assert user_vote.user_id == "some updated user_id"
      assert user_vote.vote_id == "some updated vote_id"
    end

    test "update_user_vote/2 with invalid data returns error changeset" do
      user_vote = user_vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user_vote(user_vote, @invalid_attrs)
      assert user_vote == Account.get_user_vote!(user_vote.id)
    end

    test "delete_user_vote/1 deletes the user_vote" do
      user_vote = user_vote_fixture()
      assert {:ok, %UserVote{}} = Account.delete_user_vote(user_vote)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user_vote!(user_vote.id) end
    end

    test "change_user_vote/1 returns a user_vote changeset" do
      user_vote = user_vote_fixture()
      assert %Ecto.Changeset{} = Account.change_user_vote(user_vote)
    end
  end
end
