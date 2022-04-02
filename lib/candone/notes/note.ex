defmodule Candone.Notes.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :content, :string
    field :name, :string

    field :people_count, :integer, virtual: true

    many_to_many :projects, Candone.Projects.Project, join_through: "projects_notes", on_delete: :delete_all, on_replace: :delete
    many_to_many :people, Candone.Contacts.Person, join_through: "notes_people", on_delete: :delete_all, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
  end
end
