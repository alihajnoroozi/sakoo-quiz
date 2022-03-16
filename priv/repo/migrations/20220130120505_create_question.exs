defmodule Mafia.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:question) do
      add :session_id, references("session")
      add :question, :string
      add :is_showing, :boolean, default: false, null: false
      add :answer_time, :integer
      add :point, :integer
      add :order, :integer
      add :is_deleted, :boolean

      timestamps()
    end

  end
end
