defmodule Candone.Repo.Migrations.CreateProjectsNotes do
  use Ecto.Migration

  def change do
    create table(:projects_notes) do
      add :project_id, references(:projects)
      add :note_id, references(:notes)
    end

    create unique_index(:projects_notes, [:project_id, :note_id])

  end
end
