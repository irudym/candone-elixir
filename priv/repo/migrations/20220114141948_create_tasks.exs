defmodule Candone.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false
      add :description, :text
      add :urgency, :integer
      add :cost, :integer, default: 0

      timestamps()
    end
  end
end
