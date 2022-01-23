defmodule Candone.Repo.Migrations.CreatePeople do
  use Ecto.Migration

  def change do
    create table(:people) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :middle_name, :string
      add :description, :text
      add :company_id, references(:companies, on_delete: :nothing)

      timestamps()
    end

    create index(:people, [:company_id])
  end
end
