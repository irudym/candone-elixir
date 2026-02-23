defmodule CandoneWeb.CompanyLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Contacts
  alias Candone.Contacts.Company

  import CandoneWeb.Components.UiComponents
  import CandoneWeb.Components.Icons

  @impl true
  def mount(_params, _session, socket) do
    sorting = :date
    {:ok, socket
      |> assign(:sorting, sorting)
      |> stream(:companies, sorted(Contacts.list_companies(), sorting))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Company")
    |> assign(:company, Contacts.get_company!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Company")
    |> assign(:company, %Company{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Companies")
    |> assign(:company, nil)
  end

  @impl true
  def handle_info({CandoneWeb.CompanyLive.FormComponent, {:saved, company}}, socket) do
    {:noreply, stream_insert(socket, :companies, company)}
  end

  @impl true
  def handle_event("sort-" <> field, _, socket) do
    sorting = String.to_existing_atom(field)
    {:noreply, socket
      |> assign(:sorting, sorting)
      |> stream(:companies, sorted(Contacts.list_companies(), sorting), reset: true)
    }
  end

  def handle_event("delete", %{"id" => id}, socket) do
    company = Contacts.get_company!(id)
    {:ok, _} = Contacts.delete_company(company)

    {:noreply, stream_delete(socket, :companies, company)}
  end

  defp sorted(items, :name), do: Enum.sort_by(items, & &1.name)
  defp sorted(items, :date), do: Enum.sort_by(items, & &1.inserted_at, {:desc, NaiveDateTime})
end
