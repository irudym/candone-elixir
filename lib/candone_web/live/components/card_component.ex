defmodule CandoneWeb.Components.CardComponent do
	import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  def card(assigns) do

 		 ~H"""
 		 	<div class={"relative cursor-pointer bg-white py-2 px-6 rounded-xl my-4 shadow-xl #{if assigns.selected, do: "border-2 border-sky-500"}"} phx-click={assigns.click} phx-value-id={assigns.value}>
        <div class="absolute left-9 w-[3px] bg-red-300 z-2 top-3 bottom-3 rounded-lg">
        </div>
        <div class="mt-1 ml-8">
          <p class="text-md mt-2">
            <%= assigns.name %>
          </p>
          <div class="felx space-x-2 text-gray-400 text-sm">
            <%= assigns.date %>
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