defmodule CandoneWeb.Components.CardComponents do
	import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS


  def project_card(assigns) do
    ~H"""
      <div class={"border-2 relative cursor-pointer border-gray-100 bg-white #{if assigns.selected, do: "bg-gray-100"} py-1 px-2 rounded-xl my-4"}
            phx-click={assigns.click}
            phx-value-id={assigns.value}
        >
        <div
            class={"absolute top-[-1px] bottom-[-1px] left-[-2px] rounded-l-xl border-primary-200 #{if assigns.selected, do: "bg-primary-300", else: "bg-primary-200"} w-[10px]"}>
        </div>
        <div class="ml-9">
          <p class="text-base mt-1">
            <%= assigns.name %>
          </p>
          <div class="space-x-2 text-gray-400 text-xs">
            <%= Calendar.strftime(assigns.date, "%d %B %Y") %>
          </div>
          <div class="mt-4 text-xs text-gray-400">Tasks: <%= assigns.tasks %></div>
        </div>
    </div>
    """
  end


  def card(assigns) do
 		 ~H"""
 		 	<div class={"relative cursor-pointer bg-white py-2 px-6 rounded-xl my-4 drop-shadow #{if assigns.selected, do: "bg-gray-100"}"} phx-click={assigns.click} phx-value-id={assigns.value}>
        <div
            class={"absolute top-[-1px] bottom-[-1px] left-[-2px] rounded-l-xl #{Map.get(assigns, :colour, "bg-primary-200")} w-[10px]"}>
        </div>

        <div class="mt-1 ml-9">
          <p class="text-base mt-2">
            <%= assigns.name %>
          </p>
          <div class="felx space-x-2 text-gray-400 text-xs">
            <%= Calendar.strftime(assigns.date, "%d %B %Y") %>
          </div>

          <div class="my-5 text-gray-400 text-sm font-light">
            <%= assigns.description %>
          </div>

          <div class="flex">
            <div class="rounded-full bg-gray-300 text-center px-3 text-sm text-gray-500 mr-2 mb-2">
            	<%= assigns.counter1 %>
            </div>
            <div class="rounded-full bg-gray-300 text-center px-3 text-sm text-gray-500 mb-2">
            	<%= assigns.counter2 %>
            </div>
          </div>

        </div>
      </div>
 		 """
  end
end
