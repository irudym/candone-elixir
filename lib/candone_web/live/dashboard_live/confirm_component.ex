defmodule CandoneWeb.DashboardLive.ConfirmComponent do
  import Phoenix.Component

  # import CandoneWeb.Components.UiComponents


  defp cancel_button(assigns) do
    ~H"""
      <a
        href="#"
        class="cursor-pointer bg-primary-100 hover:bg-primary-200 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white"
        phx-click="close_confirmation"
      >
        Cancel
      </a>
    """
  end

  defp delete_button(assigns) do
    ~H"""
      <span
        href="#"
        class="cursor-pointer bg-red-200 hover:bg-red-200 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white"
        phx-click={@event}
        phx-value-id={@item_id}
      >
        Delete
      </span>
    """
  end


  def confirm_delete(assigns) do
    ~H"""
      <div>
        <div class="mb-4">
          Are you sure you want to delete <b><%= get_name(@item) %></b> <%= get_type(@item) %>?
        </div>

        <div class="flex flex-row-reverse gap-6">
          <.cancel_button />
          <.delete_button event={"#{get_type(@item)}-delete"} item_id={get_id(@item)}/>
        </div>
      </div>
    """
  end

  defp get_name(item) do
    elem(item, 1).name
  end

  defp get_id(item) do
    elem(item, 1).id
  end

  defp get_type({:task, _}), do: "task"
  defp get_type({:note, _}), do: "note"
  defp get_type({:project, _}), do: "project"

end
