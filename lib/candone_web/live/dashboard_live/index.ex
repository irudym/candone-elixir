defmodule CandoneWeb.DashboardLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Projects

  import CandoneWeb.Components.CardComponents
  import CandoneWeb.Components.UiComponents
  import CandoneWeb.Components.Icons
  import CandoneWeb.DashboardLive.ConfirmComponent

  alias Candone.Projects.Project
  alias Candone.Tasks.Task
  alias Candone.Tasks
  alias Candone.Notes.Note
  alias Candone.Notes
  alias Candone.Contacts

  @urgency %{
    0 => "bg-primary-100",
    1 => "bg-green-200",
    2 => "bg-yellow-200",
    3 => "bg-red-200"
  }

  @stage_types [
    :tasks_backlog,
    :tasks_sprint,
    :tasks_done
  ]

  defp get_project_id(projects) do
    if List.first(projects) do
      List.first(projects).id
    else
      :none
    end
  end


  @impl true
  def mount(_params, _session, socket) do
    projects = Candone.Projects.list_projects()

    current_project_id = get_project_id(projects)


    {:ok, socket
          |> assign(:title, "Dashboard")
          |> assign(:projects, projects)
          |> assign(:current_project_id, current_project_id)
          |> assign(:page_title, "Candone")
          |> assign(:sorting, :date)
          |> assign(:hide_done, false)
          |> assign(:delete_card, nil)
          |> set_project(current_project_id)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new_project, _params) do
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :new_task, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
    |> assign(:people, Contacts.list_people_with_full_names())
  end

  defp apply_action(socket, :edit_task, %{"id" => id}) do
    task = Candone.Tasks.get_task!(id)
    # TODO: need to think about how to get rid of this re-mapping
    task = Map.put(task, :people, Enum.map(task.people, & "#{&1.id}"))

    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, task)
    |> assign(:people, Contacts.list_people_with_full_names())
  end

  defp apply_action(socket, :new_note, _params) do
    socket
    |> assign(:page_title, "New Note")
    |> assign(:note, %Note{})
    |> assign(:people, Contacts.list_people_with_full_names())
  end

  defp apply_action(socket, :edit_note, %{"id" => id}) do
    note = Candone.Notes.get_note!(id)
    # TODO: need to think about how to get rid of this re-mapping
    note = Map.put(note, :people, Enum.map(note.people, & "#{&1.id}"))

    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:note, note)
    |> assign(:people, Contacts.list_people_with_full_names())
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :show_project, %{"id" => id}) do
    socket
    |> set_project(id)
  end

  @doc """
    Set the project id and associated tasks and notes in socket
  """

  defp set_project(socket, "new"), do: socket

  defp set_project(socket, :none) do
    socket
    |> assign(:tasks_backlog, [])
    |> assign(:tasks_sprint, [])
    |> assign(:tasks_done, [])
    |> assign(:notes, [])
    |> assign(:sprint_cost, 0)
  end

  defp set_project(socket, id) do
    project = Projects.get_project!(id)

    sorting = socket.assigns.sorting
    backlog_tasks = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 0), sorting)
    sprint_tasks = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 1), sorting)
    done_tasks = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 2), sorting)

    notes = Projects.get_project_notes(project)

    sprint_cost = Enum.reduce(sprint_tasks, 0, fn task, acc -> acc + task.cost end)

    socket
    |> assign(:current_project_id, id)
    |> assign(:tasks_backlog, backlog_tasks)
    |> assign(:tasks_sprint, sprint_tasks)
    |> assign(:tasks_done, done_tasks)
    |> assign(:notes, notes)
    |> assign(:page_title, "Candone: #{project.name}")
    |> assign(:sprint_cost, sprint_cost)
  end

  @impl true
  def handle_event("project-select", %{"id" => project_id}, socket) do
    {:noreply,
      socket
      |> push_patch(to: Routes.dashboard_index_path(socket, :show_project, project_id))
    }
  end

  def handle_event("task-select", %{"id" => task_id}, socket) do
    {:noreply,
      socket
      |> push_patch(to: Routes.dashboard_index_path(socket, :edit_task, task_id))
    }
  end

  def handle_event("note-select", %{"id" => note_id}, socket) do
    {:noreply,
      socket
      |> push_patch(to: Routes.dashboard_index_path(socket, :edit_note, note_id))
    }
  end

  def handle_event("task-delete-confirm", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:noreply,
        socket
        |> assign(:delete_card, {:task, task})}
  end

  def handle_event("note-delete-confirm", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:noreply,
        socket
        |> assign(:delete_card, {:note, note})}
  end

  def handle_event("project-delete-confirm", %{"id" => id}, socket) do
    project = Projects.get_project!(id)
    {:noreply,
            socket
            |> assign(:delete_card, {:project, project})
    }
  end

  def handle_event("close_confirmation", _, socket) do
    {:noreply, socket
                |> assign(:delete_card, nil)
    }
  end

  # Drag and Drop
  def handle_event("reposition", %{"item" => id, "new" => new, "old" => old}, socket) when new != old do
    IO.inspect(id)
    update_task_stage(id, new)
    {:noreply, socket}
  end

  def handle_event("reposition", _, socket) do
    {:noreply, socket}
  end


  def handle_event("task-delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)

    # get task stage
    stage = task.stage
    {:ok, _} = Tasks.delete_task(task)

    #update only corresponding list of tasks

    project = Projects.get_project!(socket.assigns.current_project_id)
    {:noreply, socket
                |> assign(Enum.at(@stage_types, stage), Projects.get_project_tasks_with_stage(project, stage))
                |> put_flash(:info, "Task deleted")
                |> assign(:delete_card, nil)
    }
  end

  def handle_event("note-delete", %{"id" => id}, socket) do
    project = Projects.get_project!(socket.assigns.current_project_id)
    note = Notes.get_note!(id)
    {:ok, _} = Notes.delete_note(note)

    {:noreply, socket
                |> assign(:notes, Projects.get_project_notes(project))
                |> put_flash(:info, "Note deleted")
                |> assign(:delete_card, nil)
    }
  end

  def handle_event("project-delete", %{"id" => id}, socket) do
    project = Projects.get_project!(id)
    {:ok, _} = Projects.delete_project(project)

    projects = Candone.Projects.list_projects()
    current_project_id = List.first(projects).id || :none

    {:noreply, socket
                |> assign(:projects, projects)
                |> assign(:current_project_id, current_project_id)
                |> set_project(current_project_id)
                |> assign(:delete_card, nil)
                |> put_flash(:info, "Project deleted")
    }
  end

  def handle_event("hide-done", _, socket) do
    hide_done = socket.assigns.hide_done
    {:noreply, socket
              |> assign(:hide_done, !hide_done)}
  end

  def handle_event("sort-urgency", _, socket) do
    {:noreply, socket
              |> assign(:sorting, :urgency)
              |> assign(:tasks_backlog, Tasks.sort_by(socket.assigns.tasks_backlog, :urgency))
              |> assign(:tasks_sprint, Tasks.sort_by(socket.assigns.tasks_sprint, :urgency))
              |> assign(:tasks_done, Tasks.sort_by(socket.assigns.tasks_done, :urgency))
    }
  end

  def handle_event("sort-date", _, socket) do
    {:noreply, socket
              |> assign(:sorting, :date)
              |> assign(:tasks_backlog, Tasks.sort_by(socket.assigns.tasks_backlog, :date))
              |> assign(:tasks_sprint, Tasks.sort_by(socket.assigns.tasks_sprint, :date))
              |> assign(:tasks_done, Tasks.sort_by(socket.assigns.tasks_done, :date))
    }
  end

  def handle_event("sort-cost", _, socket) do
    {:noreply, socket
              |> assign(:sorting, :cost)
              |> assign(:tasks_backlog, Tasks.sort_by(socket.assigns.tasks_backlog, :cost))
              |> assign(:tasks_sprint, Tasks.sort_by(socket.assigns.tasks_sprint, :cost))
              |> assign(:tasks_done, Tasks.sort_by(socket.assigns.tasks_done, :cost))
    }
  end

  def get_colour_from_urgency(value) do
    Map.get(@urgency, value, "bg-gray-200")
  end

  defp update_task_stage(id, new_stage) do
    task = Tasks.get_task!(id)
    stage = case new_stage do
      "backlog-list" -> 0
      "sprint-list" -> 1
      "done-list" -> 2
      _ -> 0
    end

    Tasks.update_task_stage(task, stage)
  end
end
