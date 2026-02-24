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

  @stage_counts [
    :backlog_count,
    :sprint_count,
    :done_count
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
          |> assign(:sidebar_collapsed, false)
          |> set_project(:none)
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
    |> set_project(socket.assigns.current_project_id)
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
    |> stream(:tasks_backlog, [], reset: true)
    |> stream(:tasks_sprint, [], reset: true)
    |> stream(:tasks_done, [], reset: true)
    |> stream(:notes, [], reset: true)
    |> assign(:sprint_cost, 0)
    |> assign(:backlog_count, 0)
    |> assign(:sprint_count, 0)
    |> assign(:done_count, 0)
    |> assign(:notes_count, 0)
  end

  defp set_project(socket, id) do
    project = Projects.get_project!(id)

    sorting = socket.assigns.sorting
    all_tasks = Projects.get_project_tasks(project)
    grouped = Enum.group_by(all_tasks, & &1.stage)
    backlog_tasks = Tasks.sort_by(Map.get(grouped, 0, []), sorting)
    sprint_tasks = Tasks.sort_by(Map.get(grouped, 1, []), sorting)
    done_tasks = Tasks.sort_by(Map.get(grouped, 2, []), sorting)

    notes = Projects.get_project_notes(project)

    sprint_cost = update_sprint_cost(sprint_tasks)

    socket
    |> assign(:current_project_id, id)
    |> stream(:tasks_backlog, backlog_tasks, reset: true)
    |> stream(:tasks_sprint, sprint_tasks, reset: true)
    |> stream(:tasks_done, done_tasks, reset: true)
    |> stream(:notes, notes, reset: true)
    |> assign(:page_title, "Candone: #{project.name}")
    |> assign(:sprint_cost, sprint_cost)
    |> assign(:backlog_count, length(backlog_tasks))
    |> assign(:sprint_count, length(sprint_tasks))
    |> assign(:done_count, length(done_tasks))
    |> assign(:notes_count, length(notes))
  end

  defp update_sprint_cost(tasks) do
    Enum.reduce(tasks, 0, fn task, acc -> acc + (task.cost || 0) end)
  end

  @impl true
  def handle_event("projects-select", %{"id" => project_id}, socket) do
    {:noreply,
      socket
      |> push_patch(to: ~p"/dashboard/projects/#{project_id}")
    }
  end

  def handle_event("task-select", %{"id" => task_id}, socket) do
    {:noreply,
      socket
      |> push_patch(to: ~p"/dashboard/tasks/#{task_id}/edit")
    }
  end

  def handle_event("note-select", %{"id" => note_id}, socket) do
    {:noreply,
      socket
      |> push_patch(to: ~p"/dashboard/notes/#{note_id}/edit")
    }
  end

  def handle_event(event, %{"id" => id}, socket)
      when event in ["task-delete-confirm", "tasks_backlog-delete-confirm", "tasks_sprint-delete-confirm", "tasks_done-delete-confirm"] do
    task = Tasks.get_task!(id)
    {:noreply, assign(socket, :delete_card, {:task, task})}
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
    update_task_stage(id, new)


    project = Projects.get_project!(socket.assigns.current_project_id)
    sprint_tasks = Projects.get_project_tasks_with_stage(project, 1)

    {:noreply, socket
               |> assign(:sprint_cost, update_sprint_cost(sprint_tasks))
              }
  end

  def handle_event("reposition", _, socket) do
    {:noreply, socket}
  end


  def handle_event("task-delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    stage = task.stage
    {:ok, _} = Tasks.delete_task(task)

    count_key = Enum.at(@stage_counts, stage)
    {:noreply, socket
                |> stream_delete(Enum.at(@stage_types, stage), task)
                |> assign(count_key, socket.assigns[count_key] - 1)
                |> put_flash(:info, "Task deleted")
                |> assign(:delete_card, nil)
    }
  end

  def handle_event("note-delete", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:ok, _} = Notes.delete_note(note)

    {:noreply, socket
                |> stream_delete(:notes, note)
                |> assign(:notes_count, socket.assigns.notes_count - 1)
                |> put_flash(:info, "Note deleted")
                |> assign(:delete_card, nil)
    }
  end

  def handle_event("project-delete", %{"id" => id}, socket) do
    project = Projects.get_project!(id)
    {:ok, _} = Projects.delete_project(project)

    projects = Candone.Projects.list_projects()
    current_project_id = case List.first(projects) do
      nil -> :none
      project -> project.id
    end

    {:noreply, socket
                |> assign(:projects, projects)
                |> assign(:current_project_id, current_project_id)
                |> set_project(current_project_id)
                |> assign(:delete_card, nil)
                |> put_flash(:info, "Project deleted")
    }
  end

  def handle_event("toggle-sidebar", _, socket) do
    {:noreply, assign(socket, :sidebar_collapsed, !socket.assigns.sidebar_collapsed)}
  end

  def handle_event("hide-done", _, socket) do
    hide_done = socket.assigns.hide_done
    {:noreply, socket
              |> assign(:hide_done, !hide_done)
              |> update_after_show(hide_done)
              |> push_event("saveConfigHide", %{"hide_done" => !hide_done})
    }
  end



  def handle_event("sort-" <> field, _, socket) do
    sorting = sorting2symbol(field)
    {:noreply, apply_sorting(socket, sorting)
              |> push_event("saveConfigSorting", %{"sorting" => sorting})
    }
  end

  def handle_event("restore", %{"sorting" => sorting, "hide_done" => hide_done}, socket) do
    sorting = sorting2symbol(sorting)
    {:noreply, socket
                |> assign(:hide_done, string2bool(hide_done))
                |> apply_sorting(sorting)
    }
  end

  defp apply_sorting(socket, sorting) do
    project = Projects.get_project!(socket.assigns.current_project_id)
    all_tasks = Projects.get_project_tasks(project)
    grouped = Enum.group_by(all_tasks, & &1.stage)
    backlog = Tasks.sort_by(Map.get(grouped, 0, []), sorting)
    sprint = Tasks.sort_by(Map.get(grouped, 1, []), sorting)
    done = Tasks.sort_by(Map.get(grouped, 2, []), sorting)

    socket
    |> assign(:sorting, sorting)
    |> stream(:tasks_backlog, backlog, reset: true)
    |> stream(:tasks_sprint, sprint, reset: true)
    |> stream(:tasks_done, done, reset: true)
    |> assign(:backlog_count, length(backlog))
    |> assign(:sprint_count, length(sprint))
    |> assign(:done_count, length(done))
  end

  defp update_after_show(socket, true) do
    apply_sorting(socket, socket.assigns.sorting)
  end

  defp update_after_show(socket, false), do: socket

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

  defp string2bool(nil), do: true
  defp string2bool("true"), do: true
  defp string2bool(_value), do: false

  defp sorting2symbol("cost"), do: :cost
  defp sorting2symbol("urgency"), do: :urgency
  defp sorting2symbol(_value), do: :date

end
