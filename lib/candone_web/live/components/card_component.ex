defmodule CandoneWeb.Components.CardComponents do
  import Phoenix.LiveView.Helpers

  import CandoneWeb.Components.Icons


  def project_card(assigns) do
    ~H"""
      <div class={"group border-2 relative cursor-pointer border-gray-100 bg-white #{if assigns.selected, do: "bg-gray-100"} py-1 px-2 rounded-xl my-4"}
            phx-click={"#{@type}-select"}
            phx-value-id={@value}
        >
        <div
            class={"absolute top-[-1px] bottom-[-1px] left-[-2px] rounded-l-xl border-primary-200 #{if assigns.selected, do: "bg-primary-300", else: "bg-primary-200"} w-[10px]"}>
        </div>
        <!-- vertical tool bar -->
          <div class="absolute left-3 top-0 invisible group-hover:visible h-full flex flex-col-reverse py-1 ease-out duration-100">
          <.delete_button_icon type={@type} value={@value} />
        </div>
        <div class="ml-9">
          <p class="text-base mt-1">
            <%= @name %>
          </p>
          <div class="space-x-2 text-gray-400 text-xs">
            <%= Calendar.strftime(assigns.date, "%d %B %Y") %>
          </div>
          <div class="flex">
            <div class="mt-4 text-xs text-primary-200 mr-4">
              <.task_icon />
              <%= @tasks %>
            </div>
            <div class="mt-4 text-xs text-primary-200">
              <.note_icon />
              <%= @notes %>
            </div>
          </div>

        </div>
    </div>
    """
  end

  def delete_button_icon(assigns) do
    ~H"""
    <svg
      width="100%" height="100%"
      viewBox="0 0 32 32"
      version="1.1" xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve" xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class="h-7 w-7 stroke-current text-red-200 p-1 rounded-lg hover:bg-red-200 hover:text-red-50"
      phx-click={"#{@type}-delete"}
      phx-value-id={@value}
      data={[confirm: "Are you sure?"]}
    >
      <g transform="matrix(1,0,0,1,0,0.622489)">
          <path d="M4,9L28,9" style="fill:none;stroke-width:3px;"/>
          <path d="M7,9L7,26C7,26.943 8.057,28 9,28L23,28C23.943,28 25,26.943 25,26L25,9" style="fill:none;stroke-width:3px;"/>
          <path d="M13,9L13,28" style="fill:none;stroke-width:2px;"/>
          <path d="M19,9L19,28" style="fill:none;stroke-width:2px;"/>
          <path d="M11,8L11,4C11,2.255 21,2.428 21,4L21,8" style="fill:none;stroke-width:3px;"/>
      </g>
    </svg>
    """
  end


  def card(assigns) do
 		 ~H"""
 		 	<div class={"group relative cursor-pointer bg-white py-2 px-6 rounded-xl my-4 drop-shadow #{if assigns.selected, do: "bg-gray-100"}"} phx-click={"#{@type}-select"} phx-value-id={@value}>
        <div
            class={"absolute top-[-1px] bottom-[-1px] left-[-2px] rounded-l-xl #{Map.get(assigns, :colour, "bg-primary-200")} w-[10px]"}>
        </div>

        <!-- vertical tool bar -->
        <div class="absolute left-4 top-0 invisible group-hover:visible h-full flex flex-col-reverse py-3 ease-out duration-100">
          <.delete_button_icon type={@type} value={@value} />
        </div>

        <div class="mt-1 ml-9">
          <p class="text-base mt-2">
            <%= assigns.name %>
          </p>
          <div class="felx space-x-2 text-primary-200 text-xs">
            <%= Calendar.strftime(assigns.date, "%d %B %Y") %>
          </div>

          <div class="my-5 text-primary-200 text-sm font-light">
            <%= assigns.description %>
          </div>

          <div class="flex">
            <div class="rounded-full text-center py-1 text-sm text-primary-200 mr-4 mb-1">
              <.people_icon />
            	<%= assigns.counter1 %>
            </div>
            <div class="rounded-full text-center py-1 text-sm text-primary-200 mb-1">
              <.cog_icon />
            	<%= assigns.counter2 %>
            </div>
          </div>

        </div>
      </div>
 		 """
  end
end
