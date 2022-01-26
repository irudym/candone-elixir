defmodule CandoneWeb.NoteLive.Show do
  use CandoneWeb, :live_view

  alias Candone.Notes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
          |> assign(:people, Candone.Contacts.list_people_with_full_names())
    }
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:note, Notes.get_note!(id))
     # |> assign(:people, Candone.Contacts.list_people_with_full_names())
   }
  end

  defp page_title(:show), do: "Show Note"
  defp page_title(:edit), do: "Edit Note"
end
