defmodule CandoneWeb.NoteLive.FormComponent do
  use CandoneWeb, :live_component

  alias Candone.Notes

  @impl true
  def update(%{note: note} = assigns, socket) do
    changeset = Notes.change_note(note)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset =
      socket.assigns.note
      |> Notes.change_note(note_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.action, note_params)
  end

  defp save_note(socket, :edit, note_params) do
    case Notes.update_note(socket.assigns.note, note_params) do
      {:ok, _note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_note(socket, :new, note_params) do
    
    result = if socket.assigns.project_id && socket.assigns.project_id != :none do
      project = Candone.Projects.get_project!(socket.assigns.project_id)
      Notes.create_note_with_projects(note_params, [project])
    else
      Notes.create_note(note_params)
    end

    case result do
      {:ok, _note} ->
        {:noreply,
         socket
         |> put_flash(:info, "Note created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_note(socket, :new_note, note_params) do
    save_note(socket, :new, note_params)
  end

  defp save_note(socket, :edit_note, note_params) do
    save_note(socket, :edit, note_params)
  end
end
