defmodule Candone.Repo.Migrations.CreateProject do
  use Ecto.Migration

  def change do
    create table(:project) do
      add :name, :string
      add :description, :text

      timestamps()
    end
  end
end
