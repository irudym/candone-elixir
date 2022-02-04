defmodule CandoneWeb.Components.UiComponents do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  def add_button(assigns) do
    ~H"""
      <%= live_patch "+ Add #{assigns.name}", to: assigns.to, class: "bg-primary2-200 hover:bg-primary2-100 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white" %>
    """
  end


end
