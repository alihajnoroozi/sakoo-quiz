defmodule Mafia.Accounts.UserTotalPoint do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mafia.Accounts.User

  schema "user_total_point" do
    field :total_point, :integer
    belongs_to :user, User
    field :rank, :integer

    timestamps()
  end

  @doc false
  def changeset(user_total_point, attrs) do
    user_total_point
    |> cast(attrs, [:user_id, :total_point, :rank])
    |> validate_required([:user_id, :total_point])
  end

  @doc false
  def totals_point_cast(points) do
    output = for point <- points do
      %{ point: point.total_point, mobile: point.mobile, rank: point.rank }
    end
    output
  end

end
