defmodule CandoneWeb.PersonLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Contacts
  alias Candone.Contacts.Person
  alias Candone.Tasks
  alias Candone.Notes

  import CandoneWeb.Components.UiComponents
  import CandoneWeb.Components.Icons

  @impl true
  def mount(_params, _session, socket) do
    sorting = :date
    people = sorted(Contacts.list_people_with_company(), sorting)

    {:ok, socket
      |> assign(:sorting, sorting)
      |> assign(:people, people)
      |> assign(:selected_person, nil)
      |> assign(:tasks, [])
      |> assign(:notes, [])
      |> assign(:companies, [%{id: "", name: "N/A"} | Contacts.list_companies()])
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    person = Contacts.get_person_with_company!(id)
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, person)
    |> assign(:selected_person, person)
    |> load_person_data(person.id)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    person = Contacts.get_person_with_company!(id)
    socket
    |> assign(:page_title, Person.full_name(person))
    |> assign(:selected_person, person)
    |> load_person_data(person.id)
  end

  defp apply_action(socket, :index, _params) do
    case socket.assigns.people do
      [first | _] ->
        socket
        |> assign(:page_title, "People")
        |> assign(:selected_person, first)
        |> load_person_data(first.id)
      [] ->
        socket
        |> assign(:page_title, "People")
        |> assign(:selected_person, nil)
    end
  end

  defp load_person_data(socket, person_id) do
    socket
    |> assign(:tasks, Tasks.list_tasks_for_person(person_id))
    |> assign(:notes, Notes.list_notes_for_person(person_id))
  end

  @impl true
  def handle_info({CandoneWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    person = Contacts.get_person_with_company!(person.id)
    people = sorted(
      [person | Enum.reject(socket.assigns.people, & &1.id == person.id)],
      socket.assigns.sorting
    )
    {:noreply, assign(socket, :people, people)}
  end

  @impl true
  def handle_event("sort-" <> field, _, socket) do
    sorting = String.to_existing_atom(field)
    {:noreply, socket
      |> assign(:sorting, sorting)
      |> assign(:people, sorted(socket.assigns.people, sorting))
    }
  end

  def handle_event("delete", %{"id" => id}, socket) do
    person = Contacts.get_person!(id)
    {:ok, _} = Contacts.delete_person(person)

    people = Enum.reject(socket.assigns.people, & &1.id == person.id)

    selected =
      if socket.assigns.selected_person && socket.assigns.selected_person.id == person.id do
        List.first(people)
      else
        socket.assigns.selected_person
      end

    socket = socket |> assign(:people, people) |> assign(:selected_person, selected)
    socket = if selected,
      do: load_person_data(socket, selected.id),
      else: socket |> assign(:tasks, []) |> assign(:notes, [])

    {:noreply, socket}
  end

  def task_stage_label(0), do: "Backlog"
  def task_stage_label(1), do: "Sprint"
  def task_stage_label(2), do: "Done"
  def task_stage_label(_), do: "Unknown"

  def task_stage_class(0), do: "bg-sand-200 text-sand-600"
  def task_stage_class(1), do: "bg-blue-100 text-blue-600"
  def task_stage_class(2), do: "bg-green-100 text-green-600"
  def task_stage_class(_), do: "bg-sand-200 text-sand-600"

  defp sorted(items, :name), do: Enum.sort_by(items, & &1.last_name)
  defp sorted(items, :date), do: Enum.sort_by(items, & &1.inserted_at, {:desc, NaiveDateTime})
end
