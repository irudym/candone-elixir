defmodule Candone.Repo.Migrations.AddDoneAtToTasks do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      add :done_at, :naive_datetime, default: nil
    end
  end
end
