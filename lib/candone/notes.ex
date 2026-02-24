defmodule Candone.Notes do
  @moduledoc """
  The Notes context.
  """

  import Ecto.Query, warn: false
  alias Candone.Repo

  alias Candone.Notes.Note

  @doc """
  Returns the list of notes.

  ## Examples

      iex> list_notes()
      [%Note{}, ...]

  """
  def list_notes do
    query = from n in Note, left_join: p in assoc(n, :people), group_by: n.id, select_merge: %{people_count: count(p.id)}
    Repo.all(query)
  end

  @doc """
  Gets a single note.

  Raises `Ecto.NoResultsError` if the Note does not exist.

  ## Examples

      iex> get_note!(123)
      %Note{}

      iex> get_note!(456)
      ** (Ecto.NoResultsError)

  """
  def get_note!(id), do: Repo.get!(Note, id) |> Repo.preload(:people)

  @doc """
  Creates a note.

  ## Examples

      iex> create_note(%{field: value})
      {:ok, %Note{}}

      iex> create_note(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_note(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a note.

  ## Examples

      iex> update_note(note, %{field: new_value})
      {:ok, %Note{}}

      iex> update_note(note, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_note(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a note.

  ## Examples

      iex> delete_note(note)
      {:ok, %Note{}}

      iex> delete_note(note)
      {:error, %Ecto.Changeset{}}

  """
  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking note changes.

  ## Examples

      iex> change_note(note)
      %Ecto.Changeset{data: %Note{}}

  """
  def change_note(%Note{} = note, attrs \\ %{}) do
    note = if Ecto.assoc_loaded?(note.people), do: note, else: Repo.preload(note, :people)
    Note.changeset(note, attrs)
  end

  def create_note_with_projects(attrs, projects) do
    case create_note(attrs) do
      {:ok, note} ->
        {:ok, note
        |> Repo.preload(:projects)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:projects, projects)
        |> Repo.update!()}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Create a note with people

  ## Example
    iex> create_note_with_people(%{field: value}, people)
    {:ok, %Note{}}

    iex> create_note_with_people(%{field: bad_value}, people)
    {:error, %Ecto.Changeset{}}
  """
  def create_note_with_people(attrs, people) do
    case create_note(attrs) do
      {:ok, note} ->
        {:ok, note
        |> Repo.preload(:people)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:people, people)
        |> Repo.update!()}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def create_note_with_people_projects(attrs, people, project) do
    case create_note(attrs) do
      {:ok, note} ->
        {:ok, note
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

  def list_notes_for_person(person_id) do
    query = from n in Note,
      join: np in "notes_people", on: np.note_id == n.id,
      where: np.person_id == ^person_id,
      order_by: [desc: n.inserted_at]
    Repo.all(query)
  end

  def update_note_with_people(%Note{} = note, attrs, people) do
    note
    |> Repo.preload(:people)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:people, people)
    |> Note.changeset(attrs)
    |> Repo.update()
  end



end
