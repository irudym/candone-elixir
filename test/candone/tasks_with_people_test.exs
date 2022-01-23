defmodule Candone.TasksWithPeopleTest do
  use Candone.DataCase

  alias Candone.Tasks
  import Candone.ContactsFixtures
  import Candone.TasksFixtures

  defp create_people(_) do
    people = Enum.map(1..3, fn _ -> person_fixture() end)
    people_ids = Enum.join(Enum.map(people, & &1.id), ",")
    %{ people: people, people_ids: people_ids }
  end

  describe "tasks with people" do
    setup [:create_people]
    import Candone.TasksFixtures

    test "update_task_with_people/3 adds people records to a task without people", %{people: people} do
      task = Candone.TasksFixtures.task_fixture(%{})
      {:ok, task} = Tasks.update_task_with_people(task, %{}, people)

      assert length(task.people) == 3
    end

    test "update_task_with_people/3 updates a records with exisiting people list with new people list", %{people: people} do
      {:ok, task} = Candone.Tasks.create_task_with_people(%{name: "test task"}, people)

      person = person_fixture()
      {:ok, task} = Tasks.update_task_with_people(task, %{}, [person])

      assert length(task.people) == 1
    end

  end
end