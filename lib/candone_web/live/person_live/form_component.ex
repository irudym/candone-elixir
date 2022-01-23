defmodule CandoneWeb.PersonLive.FormComponent do
  use CandoneWeb, :live_component

  alias Candone.Contacts

  alias CandoneWeb.Components.SelectComponent

  @impl true
  def update(%{person: person} = assigns, socket) do
    changeset = Contacts.change_person(person)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"person" => person_params}, socket) do
    changeset =
      socket.assigns.person
      |> Contacts.change_person(person_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"person" => person_params}, socket) do
    save_person(socket, socket.assigns.action, person_params)
  end

  defp save_person(socket, :edit, person_params) do
    IO.inspect(person_params)
    case Contacts.update_person(socket.assigns.person, person_params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_person(socket, :new, person_params) do
    case Contacts.create_person(person_params) do
      {:ok, _person} ->
        {:noreply,
         socket
         |> put_flash(:info, "Person created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
