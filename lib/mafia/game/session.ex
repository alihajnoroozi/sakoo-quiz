defmodule Mafia.Game.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "session" do
    field :description, :string
    field :image_path, :string
    field :is_closed, :boolean, default: false
    field :is_published, :boolean, default: false
    field :title, :string
    field :total_vote_count, :integer, default: 0
    field :video_path, :string
    field :is_deleted, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:title, :description, :image_path, :video_path, :is_published, :is_closed, :total_vote_count, :is_deleted])
    |> validate_required([:title, :description, :image_path, :is_published, :is_closed])
  end

  @doc false
  def session_cast(sessions) do
    for session <- sessions do
      %{id: session.id, title: session.title}
    end
  end
end
