defmodule Candone.Repo.Migrations.CreateNotesPeople do
  use Ecto.Migration

  def change do
    create table(:notes_people) do
      add :person_id, references(:people)
      add :note_id, references(:notes)
    end

    create unique_index(:notes_people, [:person_id, :note_id])
  end
end
