defmodule Candone.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Candone.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        cost: 42,
        description: "some description",
        name: "some name",
        urgency: 42
      })
      |> Candone.Tasks.create_task()

    task
  end
end
