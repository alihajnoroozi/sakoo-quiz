defmodule Mafia.Game.Answer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mafia.Game.Question

  schema "answer" do
    field :alias, :string
    field :answer, :string
    field :image_path, :string
    field :count, :integer
    field :order, :integer
    field :is_correct, :boolean
    field :is_deleted, :boolean, default: false
    belongs_to :question, Question

    timestamps()
  end

  @doc false
  def changeset(answer, attrs) do
    answer
    |> cast(attrs, [:question_id, :answer, :count, :alias, :order, :is_correct, :is_deleted, :image_path])
    |> validate_required([:question_id, :answer, :order])
  end

  @doc false
  def user_cast_list(answers) do
    output = for answer <- answers do
      %{id: answer.id, order: answer.order, answer: answer.answer, image_path: answer.image_path}
    end
    output
  end
end
