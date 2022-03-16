defmodule Mafia.Repo.Migrations.CreateUserVote do
  use Ecto.Migration

  def change do
    create table(:user_vote) do
      add :user_id, references("user")
      add :session_id, references("session")
      add :answer_id, references("answer")
      add :question_id, references("question")
      add :point_gained, :integer

      timestamps()
    end

  end
end
