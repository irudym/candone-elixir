defmodule CandoneWeb.PersonLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Contacts
  alias Candone.Contacts.Person

  import CandoneWeb.Components.UiComponents

  @impl true
  def mount(_params, _session, socket) do
    new_socket =
      socket
      |> assign(:title, "Contacts")
      |> assign(:people, list_people())
      |> assign(:companies, [%{id: "", name: "N/A"} | list_companies()])
    {:ok, new_socket}
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
    |> assign(:page_title, "Listing People")
    |> assign(:person, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    person = Contacts.get_person!(id)
    {:ok, _} = Contacts.delete_person(person)

    {:noreply, assign(socket, :people, list_people())}
  end

  defp list_people do
    Contacts.list_people()
  end

  defp list_companies do
    Contacts.list_companies()
  end
end
