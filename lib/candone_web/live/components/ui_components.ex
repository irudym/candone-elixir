defmodule CandoneWeb.Components.UiComponents do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

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
        <g id="Layer1">
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
      <svg
        width="100%" height="100%"
        viewBox="0 0 32 32"
        version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve"
        xmlns:serif="http://www.serif.com/"
        style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
        class="h-4 w-4 stroke-current inline mb-1 mr-1"
      >
        <g id="Layer1">
          <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.235)">
            <path d="M241,221L235.178,221C234.865,221 234.566,220.876 234.345,220.655C234.124,220.434 234,220.135 234,219.822C234,217.191 234,210.858 234,208.243C234,207.603 234.519,207.083 235.16,207.083C237.797,207.083 244.219,207.083 246.849,207.083C247.154,207.083 247.447,207.205 247.663,207.421C247.879,207.637 248,207.929 248,208.235C248,209.956 248,213 248,213" style="fill:none;stroke-width:1.75px;"/>

          </g>
          <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.857)">
              <path d="M246,217L246,221" style="fill:none;stroke-width:1.75px;"/>
              <path d="M244,219L248,219" style="fill:none;stroke-width:1.75px;"/>
          </g>
          <g transform="matrix(1,0,0,1,-4.71429,-0.877511)">
              <path d="M14,17.571L19,22.143L25.857,13" style="fill:none;stroke-width:3px;"/>
          </g>
        </g>
      </svg>
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
        <g id="Layer1">
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
