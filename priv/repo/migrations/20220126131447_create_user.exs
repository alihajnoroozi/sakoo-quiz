defmodule Mafia.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :mobile, :string
      add :username, :string
      add :is_admin, :boolean
      add :name, :string
      add :is_deleted, :boolean

      timestamps()
    end

  end
end
