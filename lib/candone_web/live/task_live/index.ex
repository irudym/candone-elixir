defmodule CandoneWeb.TaskLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Tasks
  alias Candone.Tasks.Task
  alias Candone.Contacts

  @impl true
  def mount(_params, _session, socket) do
    people = Contacts.list_people_with_full_names()

    new_socket = socket
      |> assign(:tasks, list_tasks())
      |> assign(:people, people)
      |> assign(:title, "Tasks")
    {:ok, new_socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    task = Tasks.get_task!(id)

    # task = Map.put(task, :people, Enum.map(task.people, fn val -> %{id: val.id, name: Contacts.Person.full_name(val)} end))
    task = Map.put(task, :people, Enum.map(task.people, & "#{&1.id}"))

    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, task)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, assign(socket, :tasks, list_tasks())}
  end

  defp list_tasks do
    Tasks.list_tasks()
  end
end
