defmodule Mafia.Game.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mafia.Game.Session

  schema "question" do
    field :answer_time, :integer
    field :is_showing, :boolean, default: false
    field :point, :integer
    field :question, :string
    field :order, :integer
    field :is_deleted, :boolean, default: false
    field :admin_description, :string
    belongs_to :session, Session

    timestamps()
  end

  @doc false
  def changeset(question, attrs) do
    question
    |> cast(attrs, [:session_id, :question, :is_showing, :answer_time, :point, :order, :is_deleted, :admin_description])
    |> validate_required([:session_id, :question, :is_showing, :answer_time, :point, :order])
  end


  @doc false
  def user_cast(question) do
    %{id: question.id, question: question.question, answer_time: question.answer_time, session_id: question.session_id, order: question.order, point: question.point}
  end
end
