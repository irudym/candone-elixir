defmodule CandoneWeb.TaskLive.FormComponent do
  use CandoneWeb, :live_component

  alias Candone.Tasks
  alias Candone.Contacts
  alias CandoneWeb.Components.SelectManyComponent

  @impl true
  def update(%{task: task} = assigns, socket) do
    changeset = Tasks.change_task(task)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      socket.assigns.task
      |> Tasks.change_task(task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, task_params)
  end

  defp save_task(socket, :edit, task_params) do
    people = Contacts.get_people_from_string(Map.get(task_params, "people"))

    task = Tasks.get_task!(socket.assigns.task.id)

    task = Tasks.update_task_with_people(task, task_params, people)
    #IO.inspect(task, label: "SAVE_TASK:edit/task") 
    case task do
      {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end


  defp save_task(socket, :new , task_params) do
    people = Contacts.get_people_from_string(Map.get(task_params, "people"))

    result = if socket.assigns.project_id && socket.assigns.project_id != :none do
      project = Candone.Projects.get_project!(socket.assigns.project_id)
      Tasks.create_task_with_people_projects(task_params, people, [project])
    else
      Tasks.create_task_with_people(task_params, people)
    end

    case result do
      {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "Task created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


  defp save_task(socket, :new_task, task_params) do
    save_task(socket, :new, task_params)
  end

  defp save_task(socket, :edit_task, task_params) do
    save_task(socket, :edit, task_params)
  end


end
