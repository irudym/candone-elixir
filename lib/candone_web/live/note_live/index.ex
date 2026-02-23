defmodule CandoneWeb.NoteLive.Index do
  use CandoneWeb, :live_view

  alias Candone.Notes
  alias Candone.Notes.Note

  import CandoneWeb.Components.UiComponents
  import CandoneWeb.Components.Icons

  @impl true
  def mount(_params, _session, socket) do
    sorting = :date
    {:ok, socket
      |> assign(:sorting, sorting)
      |> stream(:notes, sorted(Notes.list_notes(), sorting))
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:note, Notes.get_note!(id))
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
  def handle_info({CandoneWeb.NoteLive.FormComponent, {:saved, note}}, socket) do
    {:noreply, stream_insert(socket, :notes, note)}
  end

  @impl true
  def handle_event("sort-" <> field, _, socket) do
    sorting = String.to_existing_atom(field)
    {:noreply, socket
      |> assign(:sorting, sorting)
      |> stream(:notes, sorted(Notes.list_notes(), sorting), reset: true)
    }
  end

  def handle_event("delete", %{"id" => id}, socket) do
    note = Notes.get_note!(id)
    {:ok, _} = Notes.delete_note(note)

    {:noreply, stream_delete(socket, :notes, note)}
  end

  defp sorted(items, :name), do: Enum.sort_by(items, & &1.name)
  defp sorted(items, :date), do: Enum.sort_by(items, & &1.inserted_at, {:desc, NaiveDateTime})
end
