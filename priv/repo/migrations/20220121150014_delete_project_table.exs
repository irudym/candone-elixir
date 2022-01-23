defmodule Candone.Repo.Migrations.DeleteProjectTable do
  use Ecto.Migration

  def change do
    drop table(:project)
  end
end
