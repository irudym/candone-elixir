defmodule Candone.Repo.Migrations.FixForeignKeysAndAddStageIndex do
  use Ecto.Migration

  def up do
    # Fix tasks_people foreign keys to cascade on delete
    drop constraint(:tasks_people, "tasks_people_task_id_fkey")
    drop constraint(:tasks_people, "tasks_people_person_id_fkey")

    alter table(:tasks_people) do
      modify :task_id, references(:tasks, on_delete: :delete_all), from: references(:tasks, on_delete: :nothing)
      modify :person_id, references(:people, on_delete: :delete_all), from: references(:people, on_delete: :nothing)
    end

    # Fix projects_tasks foreign keys to cascade on delete
    drop constraint(:projects_tasks, "projects_tasks_task_id_fkey")
    drop constraint(:projects_tasks, "projects_tasks_project_id_fkey")

    alter table(:projects_tasks) do
      modify :task_id, references(:tasks, on_delete: :delete_all), from: references(:tasks, on_delete: :nothing)
      modify :project_id, references(:projects, on_delete: :delete_all), from: references(:projects, on_delete: :nothing)
    end

    # Fix projects_notes foreign keys to cascade on delete
    drop constraint(:projects_notes, "projects_notes_note_id_fkey")
    drop constraint(:projects_notes, "projects_notes_project_id_fkey")

    alter table(:projects_notes) do
      modify :note_id, references(:notes, on_delete: :delete_all), from: references(:notes, on_delete: :nothing)
      modify :project_id, references(:projects, on_delete: :delete_all), from: references(:projects, on_delete: :nothing)
    end

    # Fix notes_people foreign keys to cascade on delete
    drop constraint(:notes_people, "notes_people_note_id_fkey")
    drop constraint(:notes_people, "notes_people_person_id_fkey")

    alter table(:notes_people) do
      modify :note_id, references(:notes, on_delete: :delete_all), from: references(:notes, on_delete: :nothing)
      modify :person_id, references(:people, on_delete: :delete_all), from: references(:people, on_delete: :nothing)
    end

    # Add index on tasks.stage for frequent filtering
    create index(:tasks, [:stage])
  end

  def down do
    drop index(:tasks, [:stage])

    drop constraint(:notes_people, "notes_people_note_id_fkey")
    drop constraint(:notes_people, "notes_people_person_id_fkey")

    alter table(:notes_people) do
      modify :note_id, references(:notes, on_delete: :nothing), from: references(:notes, on_delete: :delete_all)
      modify :person_id, references(:people, on_delete: :nothing), from: references(:people, on_delete: :delete_all)
    end

    drop constraint(:projects_notes, "projects_notes_note_id_fkey")
    drop constraint(:projects_notes, "projects_notes_project_id_fkey")

    alter table(:projects_notes) do
      modify :note_id, references(:notes, on_delete: :nothing), from: references(:notes, on_delete: :delete_all)
      modify :project_id, references(:projects, on_delete: :nothing), from: references(:projects, on_delete: :delete_all)
    end

    drop constraint(:projects_tasks, "projects_tasks_task_id_fkey")
    drop constraint(:projects_tasks, "projects_tasks_project_id_fkey")

    alter table(:projects_tasks) do
      modify :task_id, references(:tasks, on_delete: :nothing), from: references(:tasks, on_delete: :delete_all)
      modify :project_id, references(:projects, on_delete: :nothing), from: references(:projects, on_delete: :delete_all)
    end

    drop constraint(:tasks_people, "tasks_people_task_id_fkey")
    drop constraint(:tasks_people, "tasks_people_person_id_fkey")

    alter table(:tasks_people) do
      modify :task_id, references(:tasks, on_delete: :nothing), from: references(:tasks, on_delete: :delete_all)
      modify :person_id, references(:people, on_delete: :nothing), from: references(:people, on_delete: :delete_all)
    end
  end
end
