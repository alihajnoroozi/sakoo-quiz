defmodule Mafia.Repo.Migrations.CreateUserTotalPoint do
  use Ecto.Migration

  def change do
    create table(:user_total_point) do
      add :user_id, references("user")
      add :total_point, :integer
      add :rank, :integer

      timestamps()
    end

  end
end
