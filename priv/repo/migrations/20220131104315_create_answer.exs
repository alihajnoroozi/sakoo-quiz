defmodule Mafia.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answer) do
      add :question_id, references("question")
      add :answer, :string
      add :image_path, :string
      add :count, :integer
      add :alias, :string
      add :order, :integer
      add :is_correct, :boolean, default: false
      add :is_deleted, :boolean

      timestamps()
    end

  end
end
