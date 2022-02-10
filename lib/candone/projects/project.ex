defmodule Candone.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :name, :string

    field :task_count, :integer, virtual: true
    field :note_count, :integer, virtual: true

    many_to_many :tasks, Candone.Tasks.Task, join_through: "projects_tasks", on_delete: :delete_all, on_replace: :delete
    many_to_many :notes, Candone.Notes.Note, join_through: "projects_notes", on_delete: :delete_all, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
