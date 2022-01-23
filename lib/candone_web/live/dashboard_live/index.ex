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
    tasks = if current_project_id != :none do
      project = Projects.get_project!(current_project_id)
      Projects.get_project_tasks(project)
    else
      []
    end
    {:ok, socket
          |> assign(:projects, projects)
          |> assign(:notes, [])
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
    IO.inspect(socket, label: "Dashboard/New Task/socket")
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

  @impl true
  def handle_event("project-select", %{"id" => project_id} = params, socket) do
    IO.inspect(params, label: "Project click event")

    project = Projects.get_project!(project_id)
    tasks = Projects.get_project_tasks(project)

    IO.inspect(tasks, label: "Project-select/tasks")

    {:noreply, 
      socket
      |> assign(:current_project_id, project_id)
      |> assign(:tasks, tasks)
    }  
  end
end
