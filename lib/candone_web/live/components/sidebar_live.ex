defmodule CandoneWeb.SidebarLive do
  use CandoneWeb, :live_component

  alias Candone.Projects

  import CandoneWeb.Components.CardComponents
  import CandoneWeb.Components.UiComponents

  @impl true
  def mount(socket) do
    projects = Projects.list_projects()

    {:ok, socket
      |> assign(:sidebar_collapsed, false)
      |> assign(:delete_item, nil)
      |> assign(:projects, projects)
      |> assign(:current_project_id, :none)
    }
  end

  @impl true
  def update(assigns, socket) do
    current_project_id = Map.get(assigns, :current_project_id, :none)
    {:ok, assign(socket, :current_project_id, current_project_id)}
  end

  @impl true
  def handle_event("toggle-sidebar", _, socket) do
    {:noreply, assign(socket, :sidebar_collapsed, !socket.assigns.sidebar_collapsed)}
  end

  def handle_event("projects-select", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/dashboard/projects/#{id}")}
  end

  def handle_event("projects-delete-confirm", %{"id" => id}, socket) do
    project = Projects.get_project!(id)
    {:noreply, assign(socket, :delete_item, {:project, project})}
  end

  def handle_event("project-delete", %{"id" => id}, socket) do
    project = Projects.get_project!(id)
    {:ok, _} = Projects.delete_project(project)

    projects = Projects.list_projects()

    {:noreply, socket
      |> assign(:projects, projects)
      |> assign(:delete_item, nil)
    }
  end

  def handle_event("close_confirmation", _, socket) do
    {:noreply, assign(socket, :delete_item, nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <aside class={"sidebar #{if @sidebar_collapsed, do: "sidebar-collapsed"}"}>
      <%= if @delete_item do %>
        <.modal title="Delete">
          <div>
            <div class="mb-4 text-sand-900 text-sm">
              Are you sure you want to delete <b><%= get_item_name(@delete_item) %></b> <%= get_item_type(@delete_item) %>?
            </div>
            <div class="flex flex-row-reverse gap-4">
              <a
                href="#"
                class="cursor-pointer filter-btn font-semibold"
                phx-click="close_confirmation"
                phx-target={@myself}
              >Cancel</a>
              <span
                class="cursor-pointer py-2 px-5 text-sm leading-5 rounded-lg font-semibold text-white bg-red-200"
                phx-click={"#{get_item_type(@delete_item)}-delete"}
                phx-value-id={get_item_id(@delete_item)}
                phx-target={@myself}
              >Delete</span>
            </div>
          </div>
        </.modal>
      <% end %>

      <!-- Sidebar header -->
      <div class="flex items-center justify-between pt-4 px-3.5 pb-3 gap-2">
        <%= if !@sidebar_collapsed do %>
          <div class="flex items-center gap-2.5 overflow-hidden">
            <div class="workspace-icon">C</div>
            <div>
              <div class="text-[13.5px] font-bold text-sand-900 whitespace-nowrap">
                Candone
              </div>
              <div class="text-[10.5px] text-[#9a9a9a] whitespace-nowrap">
                Task Manager
              </div>
            </div>
          </div>
        <% end %>
        <button
          phx-click="toggle-sidebar"
          phx-target={@myself}
          class="bg-transparent border-0 text-[#9a9a9a] text-base cursor-pointer py-0.5 px-1.5 rounded shrink-0"
        >
          <%= if @sidebar_collapsed, do: "›", else: "‹" %>
        </button>
      </div>

      <%= if !@sidebar_collapsed do %>
        <!-- Navigation -->
        <div class="px-2 py-1">
          <a href="/" class="sidebar-nav-item sidebar-nav-item-active">
            <span class="text-sm w-5 text-center">◫</span>
            <span>Board</span>
          </a>
          <a href="/people" class="sidebar-nav-item">
            <span class="text-sm w-5 text-center">⌂</span>
            <span>People</span>
          </a>
          <a href="/notes" class="sidebar-nav-item">
            <span class="text-sm w-5 text-center">☰</span>
            <span>Notes</span>
          </a>
          <a href="/companies" class="sidebar-nav-item">
            <span class="text-sm w-5 text-center">◷</span>
            <span>Companies</span>
          </a>
        </div>

        <div class="nav-divider"></div>
        <!-- Projects section -->
        <div class="flex items-center justify-between px-3.5">
          <div class="nav-section-label">Projects</div>
          <.add_project_button to={~p"/dashboard/projects/new"} />
        </div>

        <div class="p-2 flex-1 overflow-y-auto">
          <%= for project <- @projects do %>
            <.project_card
              name={project.name}
              date={project.inserted_at}
              tasks={project.task_count}
              notes={project.note_count}
              type="projects"
              value={"#{project.id}"}
              selected={"#{project.id}" == "#{@current_project_id}"}
              target={@myself}
            />
          <% end %>
        </div>

      <% end %>
    </aside>
    """
  end

  defp get_item_name(item), do: elem(item, 1).name
  defp get_item_id(item), do: elem(item, 1).id
  defp get_item_type({:project, _}), do: "project"
  defp get_item_type({:note, _}), do: "note"
end
