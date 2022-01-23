defmodule Candone.Contacts.Person do
  use Ecto.Schema
  import Ecto.Changeset

  schema "people" do
    field :description, :string
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    # field :company_id, :id

    belongs_to :company, Candone.Contacts.Company
    # many_to_many :tasks, Candone.Tasks.Task, join_through: "tasks_people"

    timestamps()
  end

  @doc false
  def changeset(person, attrs) do
    person
    |> cast(attrs, [:first_name, :last_name, :middle_name, :description, :company_id])
    |> foreign_key_constraint(:tasks, name: :tasks_people)
    #|> no_assoc_constraint(:tasks, name: :tasks_people_person_id_fkey)
    |> validate_required([:first_name, :last_name])
  end

  @doc """
  Merges a person's first_name, middle, and last name into one string
  """
  def full_name(person) do
    [person.first_name, person.middle_name, person.last_name]
    |> Enum.reject(& &1 == nil)
    |> Enum.map(&String.trim/1) 
    |> Enum.reject(& &1 == "") 
    |> Enum.join(" ")
  end 

  
end
