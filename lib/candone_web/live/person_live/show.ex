defmodule CandoneWeb.PersonLive.Show do
  use CandoneWeb, :live_view

  alias Candone.Contacts
  alias Candone.Contacts.Person

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:person, Contacts.get_person_with_company!(id))
     |> assign(:companies, [%{id: "", name: "N/A"} | Contacts.list_companies()])}
  end

  @impl true
  def handle_info({CandoneWeb.PersonLive.FormComponent, {:saved, person}}, socket) do
    {:noreply, assign(socket, :person, Contacts.get_person_with_company!(person.id))}
  end

  defp page_title(:show), do: "Show Person"
  defp page_title(:edit), do: "Edit Person"
end
