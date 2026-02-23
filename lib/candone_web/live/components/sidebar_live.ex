defmodule CandoneWeb.SidebarLive do
  use CandoneWeb, :live_component

  alias Candone.Projects
  alias Candone.Notes

  import CandoneWeb.Components.CardComponents
  import CandoneWeb.Components.UiComponents
  import CandoneWeb.Components.Icons

  @impl true
  def mount(socket) do
    projects = Projects.list_projects()

    {:ok, socket
      |> assign(:sidebar_collapsed, false)
      |> assign(:delete_item, nil)
      |> assign(:projects, projects)
      |> assign(:notes, [])
      |> assign(:current_project_id, :none)
    }
  end

  @impl true
  def update(assigns, socket) do
    current_project_id = Map.get(assigns, :current_project_id, :none)
    prev_project_id = socket.assigns.current_project_id

    socket = assign(socket, :current_project_id, current_project_id)

    socket =
      if current_project_id != prev_project_id do
        if current_project_id != :none do
          project = Projects.get_project!(current_project_id)
          notes = Projects.get_project_notes(project)
          assign(socket, :notes, notes)
        else
          assign(socket, :notes, [])
        end
      else
        socket
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("toggle-sidebar", _, socket) do
    {:noreply, assign(socket, :sidebar_collapsed, !socket.assigns.sidebar_collapsed)}
  end

  def handle_event("projects-select", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/dashboard/projects/#{id}")}
  end

  def handle_event("note-select", %{"id" => id}, socket) do
    {:noreply, push_navigate(socket, to: ~p"/notes/#{id}")}
  end

  def handle_event("projects-delete-confirm", %{"id" => id}, socket) do
    project = Projects.get_project!(id)
    {:noreply, assign(socket, :delete_item, {:project, project})}
  end

  def handle_event("note-delete-confirm", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:noreply, assign(socket, :delete_item, {:note, note})}
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

  def handle_event("note-delete", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:ok, _} = Notes.delete_note(note)

    notes =
      if socket.assigns.current_project_id != :none do
        project = Projects.get_project!(socket.assigns.current_project_id)
        Projects.get_project_notes(project)
      else
        []
      end

    {:noreply, socket
      |> assign(:notes, notes)
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
            <div class="mb-4" style="color: #3d3d4a; font-size: 14px;">
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
                class="cursor-pointer py-2 px-5 text-sm leading-5 rounded-lg font-semibold text-white"
                style="background: #c75c5c;"
                phx-click={"#{get_item_type(@delete_item)}-delete"}
                phx-value-id={get_item_id(@delete_item)}
                phx-target={@myself}
              >Delete</span>
            </div>
          </div>
        </.modal>
      <% end %>

      <!-- Sidebar header -->
      <div style="display: flex; align-items: center; justify-content: space-between; padding: 16px 14px 12px; gap: 8px;">
        <%= if !@sidebar_collapsed do %>
          <div style="display: flex; align-items: center; gap: 10px; overflow: hidden;">
            <div class="workspace-icon">C</div>
            <div>
              <div style="font-size: 13.5px; font-weight: 700; color: #3d3d4a; white-space: nowrap;">
                Candone
              </div>
              <div style="font-size: 10.5px; color: #9a9a9a; white-space: nowrap;">
                Task Manager
              </div>
            </div>
          </div>
        <% end %>
        <button
          phx-click="toggle-sidebar"
          phx-target={@myself}
          style="background: none; border: none; color: #9a9a9a; font-size: 16px; cursor: pointer; padding: 2px 6px; border-radius: 4px; flex-shrink: 0;"
        >
          <%= if @sidebar_collapsed, do: "›", else: "‹" %>
        </button>
      </div>

      <%= if !@sidebar_collapsed do %>
        <!-- Navigation -->
        <div style="padding: 4px 8px;">
          <a href="/" class="sidebar-nav-item sidebar-nav-item-active">
            <span style="font-size: 14px; width: 20px; text-align: center;">◫</span>
            <span>Board</span>
          </a>
          <a href="/people" class="sidebar-nav-item">
            <span style="font-size: 14px; width: 20px; text-align: center;">⌂</span>
            <span>People</span>
          </a>
          <a href="/notes" class="sidebar-nav-item">
            <span style="font-size: 14px; width: 20px; text-align: center;">☰</span>
            <span>Notes</span>
          </a>
          <a href="/companies" class="sidebar-nav-item">
            <span style="font-size: 14px; width: 20px; text-align: center;">◷</span>
            <span>Companies</span>
          </a>
        </div>

        <div class="nav-divider"></div>
        <!-- Projects section -->
        <div style="display: flex; align-items: center; justify-content: space-between; padding: 0 14px;">
          <div class="nav-section-label">Projects</div>
          <.add_project_button to={~p"/dashboard/projects/new"} />
        </div>

        <div style="padding: 8px 8px; flex: 1; overflow-y: auto;">
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

        <div class="nav-divider"></div>
        <!-- Notes section in sidebar -->
        <div style="display: flex; align-items: center; justify-content: space-between; padding: 0 14px;">
          <div class="nav-section-label">Notes</div>
          <.add_note_button to={~p"/dashboard/notes/new"} />
        </div>

        <div style="padding: 4px 8px; max-height: 200px; overflow-y: auto; margin-bottom: 8px;">
          <%= for note <- @notes do %>
            <div class="sidebar-nav-item group" phx-click="note-select" phx-value-id={note.id} phx-target={@myself}>
              <span style="font-size: 11px; width: 20px; text-align: center;">●</span>
              <span style="flex: 1; overflow: hidden; text-overflow: ellipsis;">
                <%= note.name %>
              </span>
              <div class="invisible group-hover:visible">
                <.delete_button_icon type="note" value={note.id} target={@myself} />
              </div>
            </div>
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
