defmodule Mafia.Accounts.UserVote do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mafia.Game.Answer
  alias Mafia.Game.Question
  alias Mafia.Game.Session
  alias Mafia.Accounts.User

  schema "user_vote" do
    belongs_to :user, User
    belongs_to :answer, Answer
    belongs_to :question, Question
    belongs_to :session, Session
    field :point_gained, :integer

    timestamps()
  end

  @doc false
  def changeset(user_vote, attrs) do
    user_vote
    |> cast(attrs, [:user_id, :answer_id, :question_id, :session_id, :point_gained])
    |> validate_required([:user_id, :answer_id, :question_id, :session_id])
  end

  @doc false
  def changeset_submit(user_vote, attrs) do
    user_vote
    |> cast(attrs, [:answer_id])
    |> validate_required([:answer_id])
  end
end
