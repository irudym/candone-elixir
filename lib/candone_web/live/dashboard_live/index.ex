defmodule CandoneWeb.DashboardLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Projects
  import CandoneWeb.Components.CardComponent
  alias Candone.Projects.Project
  alias Candone.Tasks.Task
  alias Candone.Notes.Note
  alias Candone.Contacts


  @impl true
  def mount(_params, _session, socket) do
    projects = Candone.Projects.list_projects()
    current_project_id = List.first(projects).id || :none
    { tasks, notes } = if current_project_id != :none do
      project = Projects.get_project!(current_project_id)
      { Projects.get_project_tasks(project), Projects.get_project_notes(project) }
    else
      { [], [] }
    end
    {:ok, socket
          |> assign(:projects, projects)
          |> assign(:notes, notes)
          |> assign(:current_project_id, current_project_id)
          |> assign(:tasks, tasks)
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
  
  defp set_project(socket, id) do
    IO.inspect(id, label: "SET_PROJECT/id:")
    project = Projects.get_project!(id)
    tasks = Projects.get_project_tasks(project)
    notes = Projects.get_project_notes(project)

    socket
    |> assign(:current_project_id, id)
    |> assign(:tasks, tasks)
    |> assign(:notes, notes)  
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
end
