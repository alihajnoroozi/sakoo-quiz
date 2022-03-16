defmodule Mafia.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :is_admin, :boolean
    field :mobile, :string
    field :name, :string
    field :username, :string
    field :is_deleted, :boolean, default: false


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:mobile, :username, :is_admin, :name, :is_deleted])
    |> validate_required([:mobile])
  end

  @doc false
  def changeset_verify(user, attrs) do
    user
    |> cast(attrs, [:mobile])
    |> validate_required([:mobile])
    |> validate_format(:mobile, ~r/09[0-9]{9}/)
    |> validate_length(:mobile, is: 11)
  end
end
