defmodule Candone.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :cost, :integer
    field :description, :string
    field :name, :string
    field :urgency, :integer
    field :stage, :integer

    field :people_count, :integer, virtual: true

    many_to_many :people, Candone.Contacts.Person, join_through: "tasks_people", on_delete: :delete_all, on_replace: :delete
    many_to_many :projects, Candone.Projects.Project, join_through: "projects_tasks", on_delete: :delete_all, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :urgency, :cost, :stage])
   #  |> cast_assoc(:people, with: &Candone.Contacts.Person.changeset/2)
    |> foreign_key_constraint(:people)
    |> validate_required([:name])
  end

  @doc """
    Get a string representation of the stage 
  """
  def get_stage(%{stage: 0}), do: "In Backlog"
  def get_stage(%{stage: 1}), do: "In Srint"
  def get_stage(%{stage: 2}), do: "Done"
end
