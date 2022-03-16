defmodule Mafia.GameTest do
  use Mafia.DataCase

  alias Mafia.Game

  describe "session" do
    alias Mafia.Game.Session

    @valid_attrs %{description: "some description", image_path: "some image_path", is_closed: true, is_published: true, title: "some title", total_vote_count: 42, video_path: "some video_path"}
    @update_attrs %{description: "some updated description", image_path: "some updated image_path", is_closed: false, is_published: false, title: "some updated title", total_vote_count: 43, video_path: "some updated video_path"}
    @invalid_attrs %{description: nil, image_path: nil, is_closed: nil, is_published: nil, title: nil, total_vote_count: nil, video_path: nil}

    def session_fixture(attrs \\ %{}) do
      {:ok, session} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_session()

      session
    end

    test "list_session/0 returns all session" do
      session = session_fixture()
      assert Game.list_session() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Game.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      assert {:ok, %Session{} = session} = Game.create_session(@valid_attrs)
      assert session.description == "some description"
      assert session.image_path == "some image_path"
      assert session.is_closed == true
      assert session.is_published == true
      assert session.title == "some title"
      assert session.total_vote_count == 42
      assert session.video_path == "some video_path"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      assert {:ok, %Session{} = session} = Game.update_session(session, @update_attrs)
      assert session.description == "some updated description"
      assert session.image_path == "some updated image_path"
      assert session.is_closed == false
      assert session.is_published == false
      assert session.title == "some updated title"
      assert session.total_vote_count == 43
      assert session.video_path == "some updated video_path"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_session(session, @invalid_attrs)
      assert session == Game.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Game.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Game.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Game.change_session(session)
    end
  end

  describe "question" do
    alias Mafia.Game.Question

    @valid_attrs %{answer_time: 42, is_showing: true, point: 42, question: "some question", session_id: 42}
    @update_attrs %{answer_time: 43, is_showing: false, point: 43, question: "some updated question", session_id: 43}
    @invalid_attrs %{answer_time: nil, is_showing: nil, point: nil, question: nil, session_id: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_question()

      question
    end

    test "list_question/0 returns all question" do
      question = question_fixture()
      assert Game.list_question() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Game.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Game.create_question(@valid_attrs)
      assert question.answer_time == 42
      assert question.is_showing == true
      assert question.point == 42
      assert question.question == "some question"
      assert question.session_id == 42
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, %Question{} = question} = Game.update_question(question, @update_attrs)
      assert question.answer_time == 43
      assert question.is_showing == false
      assert question.point == 43
      assert question.question == "some updated question"
      assert question.session_id == 43
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_question(question, @invalid_attrs)
      assert question == Game.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Game.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Game.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Game.change_question(question)
    end
  end

  describe "answer" do
    alias Mafia.Game.Answer

    @valid_attrs %{alias: "some alias", answer: "some answer", count: 42, question_id: 42}
    @update_attrs %{alias: "some updated alias", answer: "some updated answer", count: 43, question_id: 43}
    @invalid_attrs %{alias: nil, answer: nil, count: nil, question_id: nil}

    def answer_fixture(attrs \\ %{}) do
      {:ok, answer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_answer()

      answer
    end

    test "list_answer/0 returns all answer" do
      answer = answer_fixture()
      assert Game.list_answer() == [answer]
    end

    test "get_answer!/1 returns the answer with given id" do
      answer = answer_fixture()
      assert Game.get_answer!(answer.id) == answer
    end

    test "create_answer/1 with valid data creates a answer" do
      assert {:ok, %Answer{} = answer} = Game.create_answer(@valid_attrs)
      assert answer.alias == "some alias"
      assert answer.answer == "some answer"
      assert answer.count == 42
      assert answer.question_id == 42
    end

    test "create_answer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_answer(@invalid_attrs)
    end

    test "update_answer/2 with valid data updates the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{} = answer} = Game.update_answer(answer, @update_attrs)
      assert answer.alias == "some updated alias"
      assert answer.answer == "some updated answer"
      assert answer.count == 43
      assert answer.question_id == 43
    end

    test "update_answer/2 with invalid data returns error changeset" do
      answer = answer_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_answer(answer, @invalid_attrs)
      assert answer == Game.get_answer!(answer.id)
    end

    test "delete_answer/1 deletes the answer" do
      answer = answer_fixture()
      assert {:ok, %Answer{}} = Game.delete_answer(answer)
      assert_raise Ecto.NoResultsError, fn -> Game.get_answer!(answer.id) end
    end

    test "change_answer/1 returns a answer changeset" do
      answer = answer_fixture()
      assert %Ecto.Changeset{} = Game.change_answer(answer)
    end
  end

  describe "user_total_point" do
    alias Mafia.Game.UserTotalPoint

    @valid_attrs %{total_point: 42, user_id: "some user_id"}
    @update_attrs %{total_point: 43, user_id: "some updated user_id"}
    @invalid_attrs %{total_point: nil, user_id: nil}

    def user_total_point_fixture(attrs \\ %{}) do
      {:ok, user_total_point} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Game.create_user_total_point()

      user_total_point
    end

    test "list_user_total_point/0 returns all user_total_point" do
      user_total_point = user_total_point_fixture()
      assert Game.list_user_total_point() == [user_total_point]
    end

    test "get_user_total_point!/1 returns the user_total_point with given id" do
      user_total_point = user_total_point_fixture()
      assert Game.get_user_total_point!(user_total_point.id) == user_total_point
    end

    test "create_user_total_point/1 with valid data creates a user_total_point" do
      assert {:ok, %UserTotalPoint{} = user_total_point} = Game.create_user_total_point(@valid_attrs)
      assert user_total_point.total_point == 42
      assert user_total_point.user_id == "some user_id"
    end

    test "create_user_total_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Game.create_user_total_point(@invalid_attrs)
    end

    test "update_user_total_point/2 with valid data updates the user_total_point" do
      user_total_point = user_total_point_fixture()
      assert {:ok, %UserTotalPoint{} = user_total_point} = Game.update_user_total_point(user_total_point, @update_attrs)
      assert user_total_point.total_point == 43
      assert user_total_point.user_id == "some updated user_id"
    end

    test "update_user_total_point/2 with invalid data returns error changeset" do
      user_total_point = user_total_point_fixture()
      assert {:error, %Ecto.Changeset{}} = Game.update_user_total_point(user_total_point, @invalid_attrs)
      assert user_total_point == Game.get_user_total_point!(user_total_point.id)
    end

    test "delete_user_total_point/1 deletes the user_total_point" do
      user_total_point = user_total_point_fixture()
      assert {:ok, %UserTotalPoint{}} = Game.delete_user_total_point(user_total_point)
      assert_raise Ecto.NoResultsError, fn -> Game.get_user_total_point!(user_total_point.id) end
    end

    test "change_user_total_point/1 returns a user_total_point changeset" do
      user_total_point = user_total_point_fixture()
      assert %Ecto.Changeset{} = Game.change_user_total_point(user_total_point)
    end
  end
end
