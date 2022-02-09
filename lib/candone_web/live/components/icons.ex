defmodule CandoneWeb.Components.Icons do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers


  def people_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)
    ~H"""
      <svg
        width="100%" height="100%"
        viewBox="0 0 32 32"
        version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"
        xml:space="preserve" xmlns:serif="http://www.serif.com/"
        style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:1.5;"
        class={"h-4 w-4 stroke-current inline mb-1 mr-1 #{@class}"}
      >
        <g id="Layer">
            <path d="M28,29L4,29C4,29 4,19.571 16,19.571C28,19.571 28,29 28,29Z" style="fill:none;stroke-width:3px;"/>
            <circle cx="16" cy="10" r="6" style="fill:none;stroke-width:3px;"/>
        </g>
      </svg>
    """
  end

  def cog_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)
    ~H"""
      <svg
        width="100%" height="100%"
        viewBox="0 0 32 32" version="1.1" xmlns="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve"
        xmlns:serif="http://www.serif.com/"
        style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:1.5;"
        class={"h-4 w-4 stroke-current inline mb-1 mr-1 #{@class}"}
      >
          <g transform="matrix(0.923077,0,0,0.923077,1.23077,1.23077)">
            <g id="cog">
              <path d="M17.796,3.125C16.604,2.958 15.396,2.958 14.204,3.125L13.505,6.634C12.325,6.949 11.215,7.483 10.233,8.21L7.053,6.568C6.181,7.396 5.427,8.341 4.814,9.377L7.122,12.111C6.632,13.23 6.358,14.431 6.314,15.652L3.048,17.114C3.151,18.313 3.42,19.491 3.847,20.616L7.424,20.516C7.993,21.597 8.762,22.561 9.689,23.356L8.795,26.821C9.797,27.488 10.886,28.012 12.032,28.38L14.184,25.521C15.384,25.75 16.616,25.75 17.816,25.521L19.968,28.38C21.114,28.012 22.203,27.488 23.205,26.821L22.311,23.356C23.238,22.561 24.007,21.597 24.576,20.516L28.153,20.616C28.58,19.491 28.849,18.313 28.952,17.114L25.686,15.652C25.642,14.431 25.368,13.23 24.878,12.111L27.186,9.377C26.573,8.341 25.819,7.396 24.947,6.568L21.767,8.21C20.785,7.483 19.675,6.949 18.495,6.634L17.796,3.125ZM16,12.187C18.104,12.187 19.813,13.896 19.813,16C19.813,18.104 18.104,19.813 16,19.813C13.896,19.813 12.187,18.104 12.187,16C12.187,13.896 13.896,12.187 16,12.187Z" style="fill:none;stroke-width:3.25px;"/>
            </g>
          </g>
      </svg>
    """
  end

  def task_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)
    ~H"""
      <svg
        width="100%" height="100%"
        viewBox="0 0 32 32"
        version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve"
        xmlns:serif="http://www.serif.com/"
        style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
        class={"h-4 w-4 stroke-current inline mb-1 mr-1 #{@class}"}
      >
        <g id="Task">
          <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.929)">
            <path d="M248,219.856C248,220.16 247.879,220.45 247.665,220.665C247.45,220.879 247.16,221 246.856,221C244.237,221 237.829,221 235.178,221C234.865,221 234.566,220.876 234.345,220.655C234.124,220.434 234,220.135 234,219.822C234,217.191 234,210.858 234,208.243C234,207.603 234.519,207.083 235.16,207.083C237.796,207.083 244.213,207.083 246.845,207.083C247.483,207.083 248,207.601 248,208.239L248,219.856Z" style="fill:none;stroke-width:1.75px;"/>
          </g>
          <g transform="matrix(1,0,0,1,-3.92857,-1.57143)">
            <path d="M14,17.571L19,22.143L25.857,13" style="fill:none;stroke-width:3px;"/>
          </g>
        </g>
      </svg>
    """
  end

  def pen_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)
    ~H"""
    <svg
      width="100%" height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class={"h-4 w-4 stroke-current inline mb-1 mr-1 #{@class}"}
    >
      <g id="Layer2" transform="matrix(1,0,0,1,-8.18577,-2.54164)">
        <g transform="matrix(0.799028,0.601293,-0.601293,0.799028,27.9341,1.91911)">
            <path d="M4,4.071C4,4.071 4,2.071 7,2.071C10,2.071 10,4.071 10,4.071L10,23L7,29L4,23L4,4.071Z" style="fill:none;stroke-width:3px;"/>
        </g>
        <g transform="matrix(0.799028,0.601293,-0.601293,0.799028,27.9341,1.91911)">
            <path d="M4,8L10,8" style="fill:none;stroke-width:3px;stroke-linecap:butt;"/>
        </g>
      </g>
    </svg>
    """
  end


end
