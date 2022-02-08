defmodule CandoneWeb.Components.UiComponents do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  def add_button(assigns) do
    ~H"""
      <%= live_patch "+ Add #{assigns.name}", to: assigns.to, class: "bg-primary2-200 hover:bg-primary2-300 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white" %>
    """
  end

  def cancel_button(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)
    ~H"""
      <%= live_patch "Cancel",
                to: @return_to,
                id: "close",
                class: "cursor-pointer bg-primary-100 hover:bg-primary-200 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white",
                phx_click: hide_modal()
              %>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end


end
