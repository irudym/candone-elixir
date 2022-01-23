defmodule Candone.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string, null: false
      add :address, :text
      add :description, :text

      timestamps()
    end
  end
end
