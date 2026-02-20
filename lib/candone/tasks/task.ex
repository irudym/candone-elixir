defmodule Candone.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Candone.DateUtils

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :cost, :integer
    field :urgency, :integer
    field :stage, :integer

    field :people_count, :integer, virtual: true

    field :done_at, :naive_datetime, default: nil
    field :done_at_ww, :integer, default: 0

    many_to_many :people, Candone.Contacts.Person, join_through: "tasks_people", on_delete: :delete_all, on_replace: :delete
    many_to_many :projects, Candone.Projects.Project, join_through: "projects_tasks", on_delete: :delete_all, on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :cost, :urgency, :stage])
    |> validate_required([:name])
    |> change_done_at
  end

  @doc """
    Add done_at timestamp according to stage
  """
  def change_done_at(changeset) do
    stage = get_change(changeset, :stage)
    case stage do
      2 -> change(changeset, %{
                                done_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
                                done_at_ww: DateUtils.get_work_week(NaiveDateTime.utc_now)
                              })
      s when s in [0, 1] -> change(changeset, %{done_at: nil, done_at_ww: 0})
      _ -> changeset
    end
  end

  @doc """
    Get a string representation of the stage
  """
  def get_stage(%{stage: 0}), do: "In Backlog"
  def get_stage(%{stage: 1}), do: "In Sprint"
  def get_stage(%{stage: 2}), do: "Done"
end
