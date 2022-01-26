defmodule CandoneWeb.NoteLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Notes
  alias Candone.Notes.Note
  alias Candone.Contacts

  @impl true
  def mount(_params, _session, socket) do
    notes = list_notes()
    people = Contacts.list_people_with_full_names()
    {:ok, socket
          |> assign(:notes, notes)
          |> assign(:people, people)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    note = Notes.get_note!(id)
    note = Map.put(note, :people, Enum.map(note.people, & "#{&1.id}"))

    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:note, note)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Note")
    |> assign(:note, %Note{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Notes")
    |> assign(:note, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:ok, _} = Notes.delete_note(note)

    {:noreply, assign(socket, :notes, list_notes())}
  end

  defp list_notes do
    Notes.list_notes()
  end
end
