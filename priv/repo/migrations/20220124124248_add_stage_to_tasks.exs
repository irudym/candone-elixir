defmodule Candone.Repo.Migrations.AddStageToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :stage, :integer, default: 0
    end
  end
end
