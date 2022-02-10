defmodule Candone.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Candone.Repo

  alias Candone.Projects.Project

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    query = from p in Project, left_join: t in assoc(p, :tasks), left_join: n in assoc(p, :notes), group_by: p.id, select_merge: %{task_count: count(t.id), note_count: count(n.id, :distinct)}
    Repo.all(query)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end


  def get_project_tasks(project) do
    query = from t in Ecto.assoc(project, :tasks), left_join: p in assoc(t, :people), group_by: t.id, select_merge: %{people_count: count(p.id)}
    Repo.all(query)
  end

  def get_project_tasks_with_stage(project, stage) do
    query = from t in Ecto.assoc(project, :tasks), where: t.stage == ^stage, left_join: p in assoc(t, :people), group_by: t.id, select_merge: %{people_count: count(p.id)}
    Repo.all(query)
  end

  def get_project_notes(project) do
    Repo.all(Ecto.assoc(project, :notes))
  end

end
