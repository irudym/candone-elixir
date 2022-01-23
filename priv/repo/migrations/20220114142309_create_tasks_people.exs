defmodule Candone.Repo.Migrations.CreateTasksPeople do
  use Ecto.Migration

  def change do
    create table(:tasks_people) do
      add :person_id, references(:people)
      add :task_id, references(:tasks)
    end

    create unique_index(:tasks_people, [:person_id, :task_id])
  end
end
