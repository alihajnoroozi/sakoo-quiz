defmodule Mafia.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Mafia.Repo

  alias Mafia.Accounts.User

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]

  """
  def list_user do
    Repo.all(
      from(
        u in User,
        where: u.is_deleted == false,
        order_by: {:desc, [u.inserted_at]}
      )
    )
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_mobile!(mobile) do
    Repo.one(
      from(
        u in User,
        where: u.mobile == ^mobile,
      )
    )
  end


  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
#    IO.inspect(Map.fetch(attrs, "mobile"))
#    IO.inspect(attrs)
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias Mafia.Accounts.UserVote

  @doc """
  Returns the list of user_vote.

  ## Examples

      iex> list_user_vote()
      [%UserVote{}, ...]

  """
  def list_user_vote do
    Repo.all(UserVote)
  end

  @doc """
  Gets a single user_vote.

  Raises `Ecto.NoResultsError` if the User vote does not exist.

  ## Examples

      iex> get_user_vote!(123)
      %UserVote{}

      iex> get_user_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_vote!(id), do: Repo.get!(UserVote, id)

  @doc """
  Creates a user_vote.

  ## Examples

      iex> create_user_vote(%{field: value})
      {:ok, %UserVote{}}

      iex> create_user_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_vote(attrs \\ %{}) do
    %UserVote{}
    |> UserVote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_vote.

  ## Examples

      iex> update_user_vote(user_vote, %{field: new_value})
      {:ok, %UserVote{}}

      iex> update_user_vote(user_vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_vote(%UserVote{} = user_vote, attrs) do
    user_vote
    |> UserVote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_vote.

  ## Examples

      iex> delete_user_vote(user_vote)
      {:ok, %UserVote{}}

      iex> delete_user_vote(user_vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_vote(%UserVote{} = user_vote) do
    Repo.delete(user_vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_vote changes.

  ## Examples

      iex> change_user_vote(user_vote)
      %Ecto.Changeset{data: %UserVote{}}

  """
  def change_user_vote(%UserVote{} = user_vote, attrs \\ %{}) do
    UserVote.changeset(user_vote, attrs)
  end

  alias Mafia.Accounts.UserTotalPoint

  @doc """
  Returns the list of user_total_point.

  ## Examples

      iex> list_user_total_point()
      [%UserTotalPoint{}, ...]

  """
  def list_user_total_point do
    Repo.all(UserTotalPoint)
  end

  @doc """
  Gets a single user_total_point.

  Raises `Ecto.NoResultsError` if the User total point does not exist.

  ## Examples

      iex> get_user_total_point!(123)
      %UserTotalPoint{}

      iex> get_user_total_point!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_total_point!(id), do: Repo.get!(UserTotalPoint, id)

  @doc """
  Creates a user_total_point.

  ## Examples

      iex> create_user_total_point(%{field: value})
      {:ok, %UserTotalPoint{}}

      iex> create_user_total_point(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_total_point(attrs \\ %{}) do
    %UserTotalPoint{}
    |> UserTotalPoint.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_total_point.

  ## Examples

      iex> update_user_total_point(user_total_point, %{field: new_value})
      {:ok, %UserTotalPoint{}}

      iex> update_user_total_point(user_total_point, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_total_point(%UserTotalPoint{} = user_total_point, attrs) do
#    IO.inspect user_total_point
#    IO.inspect attrs
    user_total_point
    |> UserTotalPoint.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_total_point.

  ## Examples

      iex> delete_user_total_point(user_total_point)
      {:ok, %UserTotalPoint{}}

      iex> delete_user_total_point(user_total_point)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_total_point(%UserTotalPoint{} = user_total_point) do
    Repo.delete(user_total_point)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_total_point changes.

  ## Examples

      iex> change_user_total_point(user_total_point)
      %Ecto.Changeset{data: %UserTotalPoint{}}

  """
  def change_user_total_point(%UserTotalPoint{} = user_total_point, attrs \\ %{}) do
    UserTotalPoint.changeset(user_total_point, attrs)
  end


  def get_user_total_point_by_user_id!(user_id) do
    Repo.one(
      from q in UserTotalPoint,
      where: q.user_id == ^user_id
    )
  end

  alias Mafia.Accounts.UserSessionTotalPoint

  @doc """
  Returns the list of user_session_total_point.

  ## Examples

      iex> list_user_session_total_point()
      [%UserSessionTotalPoint{}, ...]

  """
  def list_user_session_total_point do
    Repo.all(UserSessionTotalPoint)
  end


  def list_user_session_total_point_by_session_id_sorted_by_rank(session_id) do
    Repo.all(
      from q in UserSessionTotalPoint,
      join: o in User,
      where: o.id == q.user_id,
      where: q.session_id == ^session_id,
      select: %{rank: q.rank, mobile: o.mobile, user_id: q.user_id, total_point: q.total_point},
      order_by: [q.rank],
      limit: 30
    )
  end

  def get_user_session_total_point_by_session_id!(session_id, user_id) do
    Repo.one(
      from q in UserSessionTotalPoint,
      where: q.user_id == ^user_id,
      where: q.session_id == ^session_id
    )
  end

  @doc """
  Gets a single user_session_total_point.

  Raises `Ecto.NoResultsError` if the User session total point does not exist.

  ## Examples

      iex> get_user_session_total_point!(123)
      %UserSessionTotalPoint{}

      iex> get_user_session_total_point!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_session_total_point!(id), do: Repo.get!(UserSessionTotalPoint, id)

  @doc """
  Creates a user_session_total_point.

  ## Examples

      iex> create_user_session_total_point(%{field: value})
      {:ok, %UserSessionTotalPoint{}}

      iex> create_user_session_total_point(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_session_total_point(attrs \\ %{}) do
    %UserSessionTotalPoint{}
    |> UserSessionTotalPoint.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_session_total_point.

  ## Examples

      iex> update_user_session_total_point(user_session_total_point, %{field: new_value})
      {:ok, %UserSessionTotalPoint{}}

      iex> update_user_session_total_point(user_session_total_point, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_session_total_point(%UserSessionTotalPoint{} = user_session_total_point, attrs) do
    user_session_total_point
    |> UserSessionTotalPoint.changeset(attrs)
    |> Repo.update()
  end


  def get_users_total_points!(page) do
    Repo.all(
      from q in UserTotalPoint,
      join: o in User,
      where: o.id == q.user_id,
      order_by: {:desc, [q.total_point]},
      select: %{total_point: q.total_point, mobile: o.mobile, user_id: q.user_id},
      limit: 30
    )
  end


  def get_user_latest_total_point!(user_id) do
    Repo.one(
      from q in UserTotalPoint,
      where: q.user_id == ^user_id
    )
  end



  @doc """
  Deletes a user_session_total_point.

  ## Examples

      iex> delete_user_session_total_point(user_session_total_point)
      {:ok, %UserSessionTotalPoint{}}

      iex> delete_user_session_total_point(user_session_total_point)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_session_total_point(%UserSessionTotalPoint{} = user_session_total_point) do
    Repo.delete(user_session_total_point)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_session_total_point changes.

  ## Examples

      iex> change_user_session_total_point(user_session_total_point)
      %Ecto.Changeset{data: %UserSessionTotalPoint{}}

  """
  def change_user_session_total_point(%UserSessionTotalPoint{} = user_session_total_point, attrs \\ %{}) do
    UserSessionTotalPoint.changeset(user_session_total_point, attrs)
  end
end
