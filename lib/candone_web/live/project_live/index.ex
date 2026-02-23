defmodule CandoneWeb.ProjectLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Projects
  alias Candone.Projects.Project

  import CandoneWeb.Components.UiComponents
  import CandoneWeb.Components.Icons

  @impl true
  def mount(_params, _session, socket) do
    sorting = :date
    {:ok, socket
      |> assign(:sorting, sorting)
      |> stream(:projects, sorted(Projects.list_projects(), sorting))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Project")
    |> assign(:project, Projects.get_project!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, %Project{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Projects")
    |> assign(:project, nil)
  end

  @impl true
  def handle_info({CandoneWeb.ProjectLive.FormComponent, {:saved, project}}, socket) do
    {:noreply, stream_insert(socket, :projects, project)}
  end

  @impl true
  def handle_event("sort-" <> field, _, socket) do
    sorting = String.to_existing_atom(field)
    {:noreply, socket
      |> assign(:sorting, sorting)
      |> stream(:projects, sorted(Projects.list_projects(), sorting), reset: true)
    }
  end

  def handle_event("delete", %{"id" => id}, socket) do
    project = Projects.get_project!(id)
    {:ok, _} = Projects.delete_project(project)

    {:noreply, stream_delete(socket, :projects, project)}
  end

  defp sorted(items, :name), do: Enum.sort_by(items, & &1.name)
  defp sorted(items, :date), do: Enum.sort_by(items, & &1.inserted_at, {:desc, NaiveDateTime})
end
