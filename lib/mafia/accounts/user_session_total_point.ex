defmodule Mafia.Accounts.UserSessionTotalPoint do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mafia.Game.Session

  schema "user_session_total_point" do
    field :total_point, :integer
    field :rank, :integer
    belongs_to :user, User
    belongs_to :session, Session

    timestamps()
  end

  @doc false
  def changeset(user_session_total_point, attrs) do
    user_session_total_point
    |> cast(attrs, [:user_id, :session_id, :total_point, :rank])
    |> validate_required([:user_id, :session_id, :total_point])
  end

end
