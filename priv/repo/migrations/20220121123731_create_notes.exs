defmodule Candone.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :name, :string
      add :content, :text

      timestamps()
    end
  end
end
