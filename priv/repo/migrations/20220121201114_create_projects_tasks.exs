defmodule Candone.Repo.Migrations.CreateProjectsTasks do
  use Ecto.Migration

  def change do
    create table(:projects_tasks) do
      add :project_id, references(:projects)
      add :task_id, references(:tasks)
    end

    create unique_index(:projects_tasks, [:project_id, :task_id])

  end
end
