defmodule Mafia.Repo.Migrations.AlterQuestion do
  use Ecto.Migration

  def change do
    alter table(:question) do
      add :admin_description, :string
    end
  end
end
