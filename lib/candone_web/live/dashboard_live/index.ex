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
  def mount(params, _session, socket) do
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
          |> set_project(:none)
    }
  end


  @impl true
  def handle_params(params, _url, socket) do
    IO.inspect("======> apply_action(_url) <======")
    IO.inspect(socket.assigns.live_action)
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
    projects = Candone.Projects.list_projects()
    current_project_id = get_project_id(projects)

    socket
    |> set_project(current_project_id)
  end

  defp apply_action(socket, :show_project, %{"id" => id}) do
    IO.inspect("======> apply_action(:show_project) <======")
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
    |> assign(:notes, [])
    |> assign(:sprint_cost, 0)
  end

  defp set_project(socket, id) do
    project = Projects.get_project!(id)

    IO.inspect("======> set_project #{id} <=======")

    sorting = socket.assigns.sorting
    backlog_tasks = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 0), sorting)
    sprint_tasks = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 1), sorting)
    done_tasks = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 2), sorting)

    notes = Projects.get_project_notes(project)

    sprint_cost = update_sprint_cost(sprint_tasks)

    socket
    |> assign(:current_project_id, id)
    |> stream(:tasks_backlog, backlog_tasks, reset: true)
    |> stream(:tasks_sprint, sprint_tasks, reset: true)
    |> stream(:tasks_done, done_tasks, reset: true)
    |> assign(:notes, notes)
    |> assign(:page_title, "Candone: #{project.name}")
    |> assign(:sprint_cost, sprint_cost)
  end

  defp update_sprint_cost(tasks) do
    Enum.reduce(tasks, 0, fn task, acc -> acc + task.cost end)
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
    IO.inspect("======> handle_event('project-delete') <======")

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
              |> assign(:hide_done, !hide_done)
              |> update_after_show(hide_done)
              |> push_event("saveConfigHide", %{"hide_done" => !hide_done})
    }
  end



  def handle_event("sort-urgency", _, socket) do
    project = Projects.get_project!(socket.assigns.current_project_id)
    backlog = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 0), :urgency)
    sprint = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 1), :urgency)
    done = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 2), :urgency)
    {:noreply, socket
              |> assign(:sorting, :urgency)
              |> stream(:tasks_backlog, backlog, reset: true)
              |> stream(:tasks_sprint, sprint, reset: true)
              |> stream(:tasks_done, done, reset: true)
              |> push_event("saveConfigSorting", %{"sorting" => :urgency})
    }
  end

  def handle_event("sort-date", _, socket) do
    project = Projects.get_project!(socket.assigns.current_project_id)
    backlog = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 0), :date)
    sprint = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 1), :date)
    done = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 2), :date)
    {:noreply, socket
              |> assign(:sorting, :date)
              |> stream(:tasks_backlog, backlog, reset: true)
              |> stream(:tasks_sprint, sprint, reset: true)
              |> stream(:tasks_done, done, reset: true)
              |> push_event("saveConfigSorting", %{"sorting" => :date})
    }
  end

  def handle_event("sort-cost", _, socket) do
    project = Projects.get_project!(socket.assigns.current_project_id)
    backlog = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 0), :cost)
    sprint = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 1), :cost)
    done = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 2), :cost)
    {:noreply, socket
              |> assign(:sorting, :cost)
              |> stream(:tasks_backlog, backlog, reset: true)
              |> stream(:tasks_sprint, sprint, reset: true)
              |> stream(:tasks_done, done, reset: true)
              |> push_event("saveConfigSorting", %{"sorting" => :cost})
    }
  end

  def handle_event("restore", %{"sorting" => sorting, "hide_done" => hide_done}, socket) do
    sorting = sorting2symbol(sorting)
    project = Projects.get_project!(socket.assigns.current_project_id)
    backlog = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 0), sorting)
    sprint = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 1), sorting)
    done = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 2), sorting)

    {:noreply, socket
                |> assign(:sorting, sorting2symbol(sorting))
                |> assign(:hide_done, string2bool(hide_done))
                |> stream(:tasks_backlog, backlog, reset: true)
                |> stream(:tasks_sprint, sprint, reset: true)
                |> stream(:tasks_done, done, reset: true)
    }
  end

  defp update_after_show(socket, true) do
    project = Projects.get_project!(socket.assigns.current_project_id)
    sorting = socket.assigns.sorting
    done = Tasks.sort_by(Projects.get_project_tasks_with_stage(project, 2), sorting)

    socket
    |> stream(:tasks_done, done, reset: true)
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
