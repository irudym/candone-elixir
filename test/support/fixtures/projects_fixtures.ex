defmodule Candone.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Candone.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        note_count: 42,
        task_count: 42
      })
      |> Candone.Projects.create_project()

    project
  end
end
