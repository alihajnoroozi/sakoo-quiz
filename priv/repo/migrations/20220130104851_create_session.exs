defmodule Mafia.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:session) do
      add :title, :string
      add :description, :string
      add :image_path, :string
      add :video_path, :string
      add :is_published, :boolean, default: false, null: false
      add :is_closed, :boolean, default: false, null: false
      add :total_vote_count, :integer
      add :is_deleted, :boolean

      timestamps()
    end

  end
end
