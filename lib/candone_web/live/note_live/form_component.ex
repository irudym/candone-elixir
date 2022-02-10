defmodule CandoneWeb.NoteLive.FormComponent do
  use CandoneWeb, :live_component

  alias Candone.Notes
  alias Candone.Contacts
  alias CandoneWeb.Components.SelectManyComponent
  alias Candone.Markdown

  import CandoneWeb.Components.UiComponents
  import CandoneWeb.Components.Icons

  @impl true
  def update(%{note: note} = assigns, socket) do
    changeset = Notes.change_note(note)

    markdown = if Map.get(assigns, :show_markdown, assigns.action == :edit_note) do
      Markdown.as_html(note.content)
    else
      ""
    end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:markdown, markdown)
     |> assign(:show_markdown, assigns.action == :edit_note)
    }
  end

  @impl true
  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset =
      socket.assigns.note
      |> Notes.change_note(note_params)
      |> Map.put(:action, :validate)

    markdown = if Map.get(socket.assigns, :show_markdown, socket.assigns.action == :edit_note) do
      Markdown.as_html(Map.get(note_params,"content"))
    else
      ""
    end

    {:noreply, socket
                |> assign(:changeset, changeset)
                |> assign(:markdown, markdown)
    }
  end

  def handle_event("save", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.action, note_params)
  end

  def handle_event("edit-note", _, socket) do
    {:noreply, socket
                |> assign(:show_markdown, false)
    }
  end

  defp save_note(socket, :edit, note_params) do
    people = Contacts.get_people_from_string(Map.get(note_params, "people"))

    note = Notes.get_note!(socket.assigns.note.id)

    note = Notes.update_note_with_people(note, note_params, people)


    case note do
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
    people = Contacts.get_people_from_string(Map.get(note_params, "people"))

    result = if Map.has_key?(socket.assigns, :project_id) && socket.assigns.project_id != :none do
      project = Candone.Projects.get_project!(socket.assigns.project_id)
      Notes.create_note_with_people_projects(note_params, people, [project])
    else
      Notes.create_note_with_people(note_params, people)
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
