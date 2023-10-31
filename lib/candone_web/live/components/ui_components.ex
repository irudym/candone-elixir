defmodule CandoneWeb.Components.UiComponents do
  import Phoenix.Component

  alias Phoenix.LiveView.JS

  import CandoneWeb.Components.Icons

  def add_button(assigns) do
    ~H"""
      <.live_patch_custom
        to={@to}
        class="bg-primary2-200 hover:bg-primary2-300 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white"
      >
        + Add <%= @name %>
      </.live_patch_custom>
    """
    # <%= live_patch "+ Add #{assigns.name}", to: assigns.to, class: "bg-primary2-200 hover:bg-primary2-300 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white" %>
  end

  def add_project_button(assigns) do
    ~H"""
    <.live_patch_custom
        to={@to}
        class="bg-primary2-200 hover:bg-primary2-300 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white"
    >
      <svg
        width="100%" height="100%"
        viewBox="0 0 32 32"
        version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve"
        xmlns:serif="http://www.serif.com/"
        class="h-4 w-4 stroke-current inline mb-1 mr-1"
        style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;">
        <g>
          <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.235)">
              <path d="M241,221L235.417,221C234.583,221 234,220.637 234,219.833L234,210L246.583,210C247.634,210 248,210.755 248,210.917L248,213" style="fill:none;stroke-width:1.75px;"/>
              <path d="M234,210.363C234,210.363 234.798,207 236,207L241,207C242.202,207 243,210 243,210" style="fill:none;stroke-width:1.75px;stroke-linecap:butt;"/>
              <path d="M246,217L246,221" style="fill:none;stroke-width:1.75px;"/>
              <path d="M244,219L248,219" style="fill:none;stroke-width:1.75px;"/>
          </g>
        </g>
      </svg>
      Add Project
      </.live_patch_custom>
    """
  end

  def add_task_button(assigns) do
    ~H"""
    <.live_patch_custom
      to={@to}
      class="bg-primary2-200 hover:bg-primary2-300 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white"
    >
      <.add_task_icon />
      Add Task
    </.live_patch_custom>
    """
  end

  def add_note_button(assigns) do
    ~H"""
    <.live_patch_custom
      to={@to}
      class="bg-primary2-200 hover:bg-primary2-300 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white"
    >
      <svg
        width="100%" height="100%"
        viewBox="0 0 32 32"
        version="1.1"
        xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
        xml:space="preserve" xmlns:serif="http://www.serif.com/"
        style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
        class="h-4 w-4 stroke-current inline mb-1 mr-1"
      >
        <g>
          <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.235)">
              <path d="M241,221L238.261,221C237.611,221 237.083,220.473 237.083,219.822L237.083,207.797C237.083,207.156 237.603,206.637 238.243,206.637C239.904,206.637 243.009,206.637 245.271,206.637L248,209.366L248,213" style="fill:none;stroke-width:1.75px;"/>
          </g>
          <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.857)">
              <path d="M246,217L246,221" style="fill:none;stroke-width:1.75px;"/>
          </g>
          <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.857)">
              <path d="M244,219L248,219" style="fill:none;stroke-width:1.75px;"/>
          </g>
          <path d="M22,4L22,10.018C22,10.56 22.44,11 22.982,11C24.683,11 28,11 28,11" style="fill:none;stroke-width:3px;stroke-linecap:butt;"/>
        </g>
      </svg>
      Add Note
    </.live_patch_custom>
    """
  end

  def add_person_button(assigns) do
    ~H"""
    <.live_patch_custom
      to={@to}
      class="bg-primary2-200 hover:bg-primary2-300 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white"
    >
      <.add_person_icon />
      Add Person
    </.live_patch_custom>
    """
  end



  def live_patch_custom(assigns) do
    assigns = assign_new(assigns, :phx_click, fn -> nil end)
    ~H"""
    <a
      class={@class}
      data-phx-link="patch"
      data-phx-link-state="push"
      href={@to}
      phx-click={@phx_click}
    >
      <%= render_slot(@inner_block) %>
    </a>
    """

  end

  def cancel_button(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)
    ~H"""
      <.link patch={@return_to} class="cursor-pointer bg-primary-100 hover:bg-primary-200 px-5 py-3 text-sm leading-5 rounded-lg font-semibold text-white" >Cancel</.link>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  def dropdown_menu(assigns) do
    ~H"""
      <div class="group font-medium py-1 text-lg">
        <%= @title %>
        <.arrow_down_icon />
        <ul class="invisible group-hover:visible absolute z-50 mt-1 w-full bg-white shadow-lg max-h-56 max-w-[14rem] rounded-md border border-primary-200 py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm">
          <%= for item <- @items do %>
            <li class="text-gray-900 cursor-pointer select-none relative py-2 pl-3 pr-9 hover:bg-primary2-200 hover:text-white">
              <span phx-click={item.click}>
                <%= item.name %>
              </span>
            </li>
          <% end %>
        </ul>
      </div>
    """
  end

  @doc """
    Create a dropdown menu with custom menu list provided through inner block
  """
  def dropdown_menu_custom(assigns) do
    ~H"""
      <div class="group font-medium py-1 text-lg">
        <%= @title %>
        <.arrow_down_icon />
        <ul class="invisible group-hover:visible absolute z-50 mt-1 w-full bg-white shadow-lg max-h-56 max-w-[14rem] rounded-md border border-primary-200 py-1 text-base ring-1 ring-black ring-opacity-5 overflow-auto focus:outline-none sm:text-sm">
          <%= render_slot(@inner_block) %>
        </ul>
      </div>
    """
  end

  def dropdown_menu_item(assigns) do
    ~H"""
      <li phx-click={@click} class="text-gray-900 cursor-pointer select-none relative py-2 pl-3 pr-9 hover:bg-primary2-200 hover:text-white">
        <span>
          <%= render_slot(@inner_block) %>
        </span>
      </li>
    """
  end


end
