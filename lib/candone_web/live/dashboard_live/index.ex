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

  defp apply_action(socket, :new_note, _params) do
    socket
    |> assign(:page_title, "New Note")
    |> assign(:note, %Note{})
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :show_project, %{"id" => id} = params) do
    IO.inspect(id, label: "Dashbord/:show_project/id")

    socket
    |> set_project(id)
  end

  @doc """
    Set the project id and associated tasks and notes in socket
  """
  defp set_project(socket, id) do
    project = Projects.get_project!(id)
    tasks = Projects.get_project_tasks(project)
    notes = Projects.get_project_notes(project)

    socket
    |> assign(:current_project_id, id)
    |> assign(:tasks, tasks)
    |> assign(:notes, notes)  
  end

  @impl true
  def handle_event("project-select", %{"id" => project_id} = params, socket) do
    {:noreply, 
      socket
      |> push_patch(to: Routes.dashboard_index_path(socket, :show_project, project_id))
    }  
  end
end
