defmodule Candone.Repo.Migrations.AddDoneAtWwToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :done_at_ww, :integer, default: 0
    end
  end
end
