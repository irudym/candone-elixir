defmodule Candone.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias Candone.Repo

  alias Candone.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    query = from t in Task, left_join: p in assoc(t, :people), group_by: t.id, select_merge: %{people_count: count(p.id)}
    Repo.all query
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    Repo.get!(Task, id) |> Repo.preload(:people)
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Create a task with people 

  ## Example 
    iex> create_task_with_people(%{field: value}, people)
    {:ok, %Task{}}

    iex> create_task_with_people(%{field: bad_value}, people)
    {:error, %Ecto.Changeset{}}
  """
  def create_task_with_people(attrs, people) do
    case create_task(attrs) do
      {:ok, task} -> 
        {:ok, task
        |> Repo.preload(:people)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:people, people)
        |> Repo.update!()}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_task_with_people_project(attrs, people, project) do
    case create_task(attrs) do
      {:ok, task} -> 
        {:ok, task
        |> Repo.preload(:people)
        |> Repo.preload(:projects)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:people, people)
        |> Ecto.Changeset.put_assoc(:projects, project)
        |> Repo.update!()}
      {:error, changeset} ->
        {:error, changeset}
    end
  end


  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def update_task_with_people(%Task{} = task, attrs, people) do
    task
    |> Repo.preload(:people)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:people, people)
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    task
    |> Repo.preload(:people)
    |> Task.changeset(attrs)
  end
end
