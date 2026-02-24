defmodule CandoneWeb.PersonLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Contacts
  alias Candone.Contacts.Person

  import CandoneWeb.Components.UiComponents
  import CandoneWeb.Components.Icons

  @impl true
  def mount(_params, _session, socket) do
    sorting = :date
    {:ok, socket
      |> assign(:sorting, sorting)
      |> stream(:people, sorted(Contacts.list_people_with_company(), sorting))
      |> assign(:companies, [%{id: "", name: "N/A"} | list_companies()])
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Person")
    |> assign(:person, Contacts.get_person!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Person")
    |> assign(:person, %Person{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:title, "Listing People")
    |> assign(:person, nil)
  end

  @impl true
  def handle_info({CandoneWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    person = Contacts.get_person_with_company!(person.id)
    {:noreply, stream_insert(socket, :people, person)}
  end

  @impl true
  def handle_event("sort-" <> field, _, socket) do
    sorting = String.to_existing_atom(field)
    {:noreply, socket
      |> assign(:sorting, sorting)
      |> stream(:people, sorted(Contacts.list_people_with_company(), sorting), reset: true)
    }
  end

  def handle_event("delete", %{"id" => id}, socket) do
    person = Contacts.get_person!(id)
    {:ok, _} = Contacts.delete_person(person)

    {:noreply, stream_delete(socket, :people, person)}
  end

  defp list_companies do
    Contacts.list_companies()
  end

  defp sorted(items, :name), do: Enum.sort_by(items, & &1.last_name)
  defp sorted(items, :date), do: Enum.sort_by(items, & &1.inserted_at, {:desc, NaiveDateTime})
end
