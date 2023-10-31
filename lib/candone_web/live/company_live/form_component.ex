defmodule CandoneWeb.CompanyLive.FormComponent do
  use CandoneWeb, :live_component
  import Phoenix.Component


  alias Candone.Contacts

  @impl true
  def update(%{company: company} = assigns, socket) do
    changeset = Contacts.change_company(company)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"company" => company_params}, socket) do
    changeset =
      socket.assigns.company
      |> Contacts.change_company(company_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"company" => company_params}, socket) do
    save_company(socket, socket.assigns.action, company_params)
  end

  defp save_company(socket, :edit, company_params) do
    case Contacts.update_company(socket.assigns.company, company_params) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:info, "Company updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_company(socket, :new, company_params) do
    case Contacts.create_company(company_params) do
      {:ok, _company} ->
        {:noreply,
         socket
         |> put_flash(:info, "Company created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
