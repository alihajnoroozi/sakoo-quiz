defmodule Mafia.Repo.Migrations.CreateUserSessionTotalPoint do
  use Ecto.Migration

  def change do
    create table(:user_session_total_point) do
      add :user_id, references("user")
      add :total_point, :integer
      add :rank, :integer
      add :session_id, references("session")

      timestamps()
    end

  end
end
