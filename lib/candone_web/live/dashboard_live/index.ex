defmodule CandoneWeb.DashboardLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Projects
  import CandoneWeb.Components.CardComponents
  alias Candone.Projects.Project
  alias Candone.Tasks.Task
  alias Candone.Notes.Note
  alias Candone.Contacts

  @urgency %{
    0 => "bg-gray-200",
    1 => "bg-green-200",
    2 => "bg-yellow-200",
    3 => "bg-red-200"
  }


  @impl true
  def mount(_params, _session, socket) do
    projects = Candone.Projects.list_projects()
    current_project_id = List.first(projects).id || :none
    
    {:ok, socket
          |> assign(:projects, projects)
          |> assign(:current_project_id, current_project_id)
          |> assign(:page_title, "Candone")
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
    |> assign(:tasks, %{backlog: [], sprint: [], done: []})
    |> assign(:notes, [])
  end

  defp set_project(socket, id) do
    project = Projects.get_project!(id)
    backlog_tasks = Projects.get_project_tasks_with_stage(project, 0)
    sprint_tasks = Projects.get_project_tasks_with_stage(project, 1)
    done_tasks = Projects.get_project_tasks_with_stage(project, 2)
    notes = Projects.get_project_notes(project)

    socket
    |> assign(:current_project_id, id)
    |> assign(:tasks, %{backlog: backlog_tasks, sprint: sprint_tasks, done: done_tasks})
    |> assign(:notes, notes)
    |> assign(:page_title, "Candone: #{project.name}")
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

  def get_colour_from_urgency(value) do
    Map.get(@urgency, value, "bg-gray-200")
  end
end
