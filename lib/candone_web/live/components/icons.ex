defmodule CandoneWeb.Components.Icons do
  import Phoenix.Component

  def delete_button_icon(assigns) do
    assigns = assign_new(assigns, :target, fn -> nil end)

    ~H"""
    <svg
      width="16"
      height="16"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class="stroke-current text-red-200 cursor-pointer hover:text-red-500 transition-colors"
      phx-click={"#{@type}-delete-confirm"}
      phx-value-id={@value}
      phx-target={@target}
    >
      <g transform="matrix(1,0,0,1,0,0.622489)">
        <path d="M4,9L28,9" style="fill:none;stroke-width:3px;" />
        <path
          d="M7,9L7,26C7,26.943 8.057,28 9,28L23,28C23.943,28 25,26.943 25,26L25,9"
          style="fill:none;stroke-width:3px;"
        />
        <path d="M13,9L13,28" style="fill:none;stroke-width:2px;" />
        <path d="M19,9L19,28" style="fill:none;stroke-width:2px;" />
        <path d="M11,8L11,4C11,2.255 21,2.428 21,4L21,8" style="fill:none;stroke-width:3px;" />
      </g>
    </svg>
    """
  end

  def trash_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> "" end)

    ~H"""
    <svg
      width="16"
      height="16"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class={"stroke-current text-red-200 cursor-pointer hover:text-red-500 transition-colors #{@class}"}
    >
      <g transform="matrix(1,0,0,1,0,0.622489)">
        <path d="M4,9L28,9" style="fill:none;stroke-width:3px;" />
        <path
          d="M7,9L7,26C7,26.943 8.057,28 9,28L23,28C23.943,28 25,26.943 25,26L25,9"
          style="fill:none;stroke-width:3px;"
        />
        <path d="M13,9L13,28" style="fill:none;stroke-width:2px;" />
        <path d="M19,9L19,28" style="fill:none;stroke-width:2px;" />
        <path d="M11,8L11,4C11,2.255 21,2.428 21,4L21,8" style="fill:none;stroke-width:3px;" />
      </g>
    </svg>
    """
  end

  def people_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class={"h-6 w-6 p-1 stroke-current inline mb-1 mr-1 #{@class}"}
    >
      <g>
        <path
          d="M28,29L4,29C4,29 4,19.571 16,19.571C28,19.571 28,29 28,29Z"
          style="fill:none;stroke-width:3px;"
        />
        <circle cx="16" cy="10" r="6" style="fill:none;stroke-width:3px;" />
      </g>
    </svg>
    """
  end

  def cog_icon(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:checked, fn -> false end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class={"h-6 w-6 p-1 stroke-current inline mb-1 mr-1 #{@class} #{if @checked, do: "rounded-md bg-primary2-200 text-white"}"}
    >
      <g transform="matrix(0.923077,0,0,0.923077,1.23077,1.23077)">
        <g>
          <path
            d="M17.796,3.125C16.604,2.958 15.396,2.958 14.204,3.125L13.505,6.634C12.325,6.949 11.215,7.483 10.233,8.21L7.053,6.568C6.181,7.396 5.427,8.341 4.814,9.377L7.122,12.111C6.632,13.23 6.358,14.431 6.314,15.652L3.048,17.114C3.151,18.313 3.42,19.491 3.847,20.616L7.424,20.516C7.993,21.597 8.762,22.561 9.689,23.356L8.795,26.821C9.797,27.488 10.886,28.012 12.032,28.38L14.184,25.521C15.384,25.75 16.616,25.75 17.816,25.521L19.968,28.38C21.114,28.012 22.203,27.488 23.205,26.821L22.311,23.356C23.238,22.561 24.007,21.597 24.576,20.516L28.153,20.616C28.58,19.491 28.849,18.313 28.952,17.114L25.686,15.652C25.642,14.431 25.368,13.23 24.878,12.111L27.186,9.377C26.573,8.341 25.819,7.396 24.947,6.568L21.767,8.21C20.785,7.483 19.675,6.949 18.495,6.634L17.796,3.125ZM16,12.187C18.104,12.187 19.813,13.896 19.813,16C19.813,18.104 18.104,19.813 16,19.813C13.896,19.813 12.187,18.104 12.187,16C12.187,13.896 13.896,12.187 16,12.187Z"
            style="fill:none;stroke-width:3.25px;"
          />
        </g>
      </g>
    </svg>
    """
  end

  def task_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class={"h-4 w-4 stroke-current inline mb-1 mr-1 #{@class}"}
    >
      <g>
        <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.929)">
          <path
            d="M248,219.856C248,220.16 247.879,220.45 247.665,220.665C247.45,220.879 247.16,221 246.856,221C244.237,221 237.829,221 235.178,221C234.865,221 234.566,220.876 234.345,220.655C234.124,220.434 234,220.135 234,219.822C234,217.191 234,210.858 234,208.243C234,207.603 234.519,207.083 235.16,207.083C237.796,207.083 244.213,207.083 246.845,207.083C247.483,207.083 248,207.601 248,208.239L248,219.856Z"
            style="fill:none;stroke-width:1.75px;"
          />
        </g>
        <g transform="matrix(1,0,0,1,-3.92857,-1.57143)">
          <path d="M14,17.571L19,22.143L25.857,13" style="fill:none;stroke-width:3px;" />
        </g>
      </g>
    </svg>
    """
  end

  def pen_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="16"
      height="16"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class={"h-4 w-4 stroke-current inline mb-1 mr-1 #{@class}"}
    >
      <g transform="matrix(1,0,0,1,-8.18577,-2.54164)">
        <g transform="matrix(0.799028,0.601293,-0.601293,0.799028,27.9341,1.91911)">
          <path
            d="M4,4.071C4,4.071 4,2.071 7,2.071C10,2.071 10,4.071 10,4.071L10,23L7,29L4,23L4,4.071Z"
            style="fill:none;stroke-width:3px;"
          />
        </g>
        <g transform="matrix(0.799028,0.601293,-0.601293,0.799028,27.9341,1.91911)">
          <path d="M4,8L10,8" style="fill:none;stroke-width:3px;stroke-linecap:butt;" />
        </g>
      </g>
    </svg>
    """
  end

  def arrow_down_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class={"h-4 w-4 inline stroke-current #{@class}"}
    >
      <g transform="matrix(1,0,0,1,-4.71429,-0.877511)">
        <path d="M6.152,11.126L19.152,27.392C19.532,27.866 20.106,28.143 20.714,28.143C21.322,28.143 21.897,27.866 22.277,27.392L35.277,11.126C35.966,10.264 35.825,9.004 34.963,8.315C34.101,7.626 32.841,7.767 32.152,8.629L20.714,22.939C20.714,22.939 9.277,8.629 9.277,8.629C8.587,7.767 7.328,7.626 6.466,8.315C5.603,9.004 5.463,10.264 6.152,11.126Z" />
      </g>
    </svg>
    """
  end

  def add_task_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
      class={"h-4 w-4 inline stroke-none fill-current #{@class}"}
    >
      <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.235)">
        <path d="M241,220.125L235.178,220.125C235.097,220.125 235.02,220.093 234.964,220.036C234.907,219.98 234.875,219.903 234.875,219.822L234.875,208.243C234.875,208.086 235.003,207.958 235.16,207.958C235.16,207.958 246.849,207.958 246.849,207.958C246.922,207.958 246.992,207.987 247.044,208.039C247.096,208.091 247.125,208.161 247.125,208.235L247.125,213C247.125,213.483 247.517,213.875 248,213.875C248.483,213.875 248.875,213.483 248.875,213C248.875,213 248.875,209.956 248.875,208.235C248.875,207.697 248.662,207.182 248.281,206.802C247.901,206.422 247.386,206.208 246.849,206.208C244.219,206.208 237.797,206.208 235.16,206.208C234.036,206.208 233.125,207.119 233.125,208.243C233.125,210.858 233.125,217.191 233.125,219.822C233.125,220.367 233.341,220.889 233.726,221.274C234.111,221.659 234.633,221.875 235.178,221.875L241,221.875C241.483,221.875 241.875,221.483 241.875,221C241.875,220.517 241.483,220.125 241,220.125Z" />
      </g>
      <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.857)">
        <path d="M245.125,217L245.125,221C245.125,221.483 245.517,221.875 246,221.875C246.483,221.875 246.875,221.483 246.875,221L246.875,217C246.875,216.517 246.483,216.125 246,216.125C245.517,216.125 245.125,216.517 245.125,217Z" />
      </g>
      <g transform="matrix(1.71429,0,0,1.71429,-397.143,-350.857)">
        <path d="M244,219.875L248,219.875C248.483,219.875 248.875,219.483 248.875,219C248.875,218.517 248.483,218.125 248,218.125L244,218.125C243.517,218.125 243.125,218.517 243.125,219C243.125,219.483 243.517,219.875 244,219.875Z" />
      </g>
      <g transform="matrix(1,0,0,1,-4.71429,-0.877511)">
        <path d="M12.988,18.678L17.988,23.25C18.3,23.535 18.718,23.676 19.14,23.636C19.561,23.597 19.946,23.381 20.2,23.043L27.057,13.9C27.554,13.238 27.419,12.297 26.757,11.8C26.095,11.303 25.154,11.438 24.657,12.1L18.792,19.92C18.792,19.92 15.012,16.464 15.012,16.464C14.401,15.906 13.452,15.948 12.893,16.559C12.334,17.17 12.377,18.12 12.988,18.678Z" />
      </g>
    </svg>
    """
  end

  def note_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
      class={"h-4 w-4 inline mb-1 mr-1 stroke-none fill-current #{@class}"}
    >
      <g transform="matrix(1.71429,0,0,1.71429,-399.786,-350.546)">
        <path d="M248.875,219.824L248.875,209.366C248.875,209.134 248.783,208.911 248.619,208.747L245.89,206.018C245.726,205.854 245.503,205.762 245.271,205.762L238.243,205.762C237.119,205.762 236.208,206.673 236.208,207.797L236.208,219.822C236.208,220.956 237.127,221.875 238.261,221.875L246.824,221.875C247.368,221.875 247.89,221.659 248.274,221.274C248.659,220.89 248.875,220.368 248.875,219.824ZM247.125,219.824C247.125,219.904 247.093,219.98 247.037,220.037C246.98,220.093 246.904,220.125 246.824,220.125L238.261,220.125C238.094,220.125 237.958,219.99 237.958,219.822C237.958,219.822 237.958,207.797 237.958,207.797C237.958,207.639 238.086,207.512 238.243,207.512C238.243,207.512 244.909,207.512 244.909,207.512C244.909,207.512 247.125,209.728 247.125,209.728L247.125,219.824Z" />
      </g>
      <g transform="matrix(1,0,0,1,-2.64286,-0.311244)">
        <path d="M23.5,9.5L23.5,4L20.5,4L20.5,10.018C20.5,11.389 21.611,12.5 22.982,12.5L28,12.5L28,9.5L23.5,9.5Z" />
      </g>
      <g transform="matrix(1,0,0,1,-2.64286,1.68876)">
        <path d="M12,11L17,11L17,9L12,9L12,11Z" />
      </g>
      <g transform="matrix(1,0,0,1,-2.64286,1.68876)">
        <path d="M12,17.311L23,17.311L23,15.311L12,15.311L12,17.311Z" />
      </g>
      <g transform="matrix(1,0,0,1,-2.64286,1.68876)">
        <path d="M12,22L23,22L23,20L12,20L12,22Z" />
      </g>
    </svg>
    """
  end

  def calendar_icon(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:checked, fn -> false end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
      class={"h-6 w-6 p-1 inline mb-1 mr-1 stroke-none fill-current #{@class} #{if @checked, do: "rounded-md bg-primary2-200 text-white"}"}
    >
      <g transform="matrix(1,0,0,1,1,-6.11067e-13)">
        <path d="M28.5,10.985C28.5,10.061 28.133,9.175 27.479,8.521C26.825,7.867 25.939,7.5 25.015,7.5C20.511,7.5 9.56,7.5 5.022,7.5C3.077,7.5 1.5,9.077 1.5,11.022C1.5,14.67 1.5,22.316 1.5,25.97C1.5,27.92 3.08,29.5 5.029,29.5L24.987,29.5C25.919,29.5 26.812,29.13 27.471,28.471C28.13,27.812 28.5,26.919 28.5,25.987C28.5,22.327 28.5,14.625 28.5,10.985ZM25.5,10.985C25.5,14.625 25.5,22.327 25.5,25.987C25.5,26.123 25.446,26.254 25.35,26.35C25.254,26.446 25.123,26.5 24.987,26.5L5.03,26.5C4.737,26.5 4.5,26.263 4.5,25.97L4.5,11.022C4.5,10.734 4.734,10.5 5.022,10.5C5.022,10.5 25.015,10.5 25.015,10.5C25.143,10.5 25.267,10.551 25.358,10.642C25.449,10.733 25.5,10.857 25.5,10.985Z" />
      </g>
      <path d="M4,16.5L28,16.5L28,13.5L4,13.5L4,16.5Z" />
      <path d="M8.5,4L8.5,11C8.5,11.828 9.172,12.5 10,12.5C10.828,12.5 11.5,11.828 11.5,11L11.5,4C11.5,3.172 10.828,2.5 10,2.5C9.172,2.5 8.5,3.172 8.5,4Z" />
      <g transform="matrix(1,0,0,1,12,0)">
        <path d="M8.5,4L8.5,11C8.5,11.828 9.172,12.5 10,12.5C10.828,12.5 11.5,11.828 11.5,11L11.5,4C11.5,3.172 10.828,2.5 10,2.5C9.172,2.5 8.5,3.172 8.5,4Z" />
      </g>
      <g transform="matrix(2,0,0,2,-9,-19)">
        <path
          d="M10.75,19C10.75,18.586 10.414,18.25 10,18.25L9,18.25C8.586,18.25 8.25,18.586 8.25,19L8.25,20C8.25,20.414 8.586,20.75 9,20.75L10,20.75C10.414,20.75 10.75,20.414 10.75,20L10.75,19Z"
          style="fill:none;"
        />
      </g>
      <g transform="matrix(2,0,0,2,-9,-15.581)">
        <path
          d="M10.75,19C10.75,18.586 10.414,18.25 10,18.25L9,18.25C8.586,18.25 8.25,18.586 8.25,19L8.25,20C8.25,20.414 8.586,20.75 9,20.75L10,20.75C10.414,20.75 10.75,20.414 10.75,20L10.75,19Z"
          style="fill:none;"
        />
      </g>
      <g transform="matrix(2,0,0,2,-3,-19)">
        <path
          d="M10.75,19C10.75,18.586 10.414,18.25 10,18.25L9,18.25C8.586,18.25 8.25,18.586 8.25,19L8.25,20C8.25,20.414 8.586,20.75 9,20.75L10,20.75C10.414,20.75 10.75,20.414 10.75,20L10.75,19Z"
          style="fill:none;"
        />
      </g>
      <g transform="matrix(2,0,0,2,-3,-15.581)">
        <path
          d="M10.75,19C10.75,18.586 10.414,18.25 10,18.25L9,18.25C8.586,18.25 8.25,18.586 8.25,19L8.25,20C8.25,20.414 8.586,20.75 9,20.75L10,20.75C10.414,20.75 10.75,20.414 10.75,20L10.75,19Z"
          style="fill:none;"
        />
      </g>
      <g transform="matrix(2,0,0,2,3,-19)">
        <path
          d="M10.75,19C10.75,18.586 10.414,18.25 10,18.25L9,18.25C8.586,18.25 8.25,18.586 8.25,19L8.25,20C8.25,20.414 8.586,20.75 9,20.75L10,20.75C10.414,20.75 10.75,20.414 10.75,20L10.75,19Z"
          style="fill:none;"
        />
      </g>
    </svg>
    """
  end

  def exclamation_icon(assigns) do
    assigns =
      assigns
      |> assign_new(:class, fn -> nil end)
      |> assign_new(:checked, fn -> false end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
      class={"h-6 w-6 p-1 inline mb-1 mr-1 stroke-none fill-current #{@class} #{if @checked, do: "rounded-md bg-primary2-200 text-white"}"}
    >
      <g transform="matrix(1,0,0,1,-0.5,0)">
        <path d="M19,5.033C19,3.91 18.09,3 16.967,3C16.639,3 16.299,3 15.973,3C14.883,3 14,3.883 14,4.973C14,8.422 14,15.514 14,18.99C14,19.523 14.212,20.034 14.589,20.411C14.966,20.788 15.477,21 16.01,21C16.352,21 16.707,21 17.048,21C17.565,21 18.062,20.794 18.428,20.428C18.794,20.062 19,19.565 19,19.048C19,15.613 19,8.524 19,5.033Z" />
      </g>
      <g transform="matrix(1,0,0,1,-0.5,0)">
        <path
          d="M20.5,19.048L20.5,5.033C20.5,3.082 18.918,1.5 16.967,1.5L15.973,1.5C14.055,1.5 12.5,3.055 12.5,4.973C12.5,8.422 12.5,15.514 12.5,18.99C12.5,19.921 12.87,20.814 13.528,21.472C14.186,22.13 15.079,22.5 16.01,22.5C16.352,22.5 16.707,22.5 17.048,22.5C17.963,22.5 18.841,22.136 19.489,21.489C20.136,20.841 20.5,19.963 20.5,19.048ZM17.5,5.033L17.5,19.048C17.5,19.168 17.452,19.283 17.368,19.368C17.283,19.452 17.168,19.5 17.048,19.5L16.01,19.5C15.875,19.5 15.745,19.446 15.649,19.351C15.554,19.255 15.5,19.125 15.5,18.99L15.5,4.973C15.5,4.712 15.712,4.5 15.973,4.5C15.973,4.5 16.967,4.5 16.967,4.5C17.261,4.5 17.5,4.739 17.5,5.033Z"
          style="fill:none;"
        />
      </g>
      <g transform="matrix(0.833333,0,0,0.833333,0.166667,7.33333)">
        <circle cx="19" cy="23" r="3" />
      </g>
      <g transform="matrix(0.833333,0,0,0.833333,0.166667,7.33333)">
        <path
          d="M19,18.2C16.351,18.2 14.2,20.351 14.2,23C14.2,25.649 16.351,27.8 19,27.8C21.649,27.8 23.8,25.649 23.8,23C23.8,20.351 21.649,18.2 19,18.2ZM19,21.8C19.662,21.8 20.2,22.338 20.2,23C20.2,23.662 19.662,24.2 19,24.2C18.338,24.2 17.8,23.662 17.8,23C17.8,22.338 18.338,21.8 19,21.8Z"
          style="fill:none;"
        />
      </g>
    </svg>
    """
  end

  def show_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
      class={"h-6 w-6 p-1 inline mb-1 mr-1 stroke-none fill-current #{@class}"}
    >
      <g transform="matrix(1,0,0,1.26667,0,-4.26667)">
        <g transform="matrix(1.07407,0,0,1.10526,-1.18519,-1.68421)">
          <path d="M3.047,14.841C3.01,14.872 2.974,14.905 2.939,14.939C2.838,15.04 2.754,15.153 2.688,15.273L2.673,15.3C2.558,15.517 2.501,15.755 2.5,15.992L2.5,16.008C2.501,16.245 2.558,16.483 2.673,16.7L2.688,16.727C2.754,16.847 2.838,16.96 2.939,17.061C2.974,17.095 3.01,17.128 3.047,17.159C3.313,17.384 5.83,19.493 8.885,21.198C11.18,22.479 13.776,23.5 16,23.5C18.224,23.5 20.82,22.479 23.115,21.198C26.17,19.493 28.687,17.384 28.953,17.159C28.99,17.128 29.026,17.095 29.061,17.061C29.162,16.96 29.246,16.847 29.312,16.727L29.327,16.7C29.442,16.483 29.499,16.245 29.5,16.008L29.5,15.992C29.499,15.755 29.442,15.517 29.327,15.3L29.312,15.273C29.246,15.153 29.162,15.04 29.061,14.939C29.026,14.905 28.99,14.872 28.953,14.841C28.687,14.616 26.17,12.507 23.115,10.802C20.82,9.521 18.224,8.5 16,8.5C13.776,8.5 11.18,9.521 8.885,10.802C5.83,12.507 3.313,14.616 3.047,14.841ZM25.583,16C24.601,15.264 23.203,14.287 21.653,13.422C19.82,12.399 17.776,11.5 16,11.5C14.224,11.5 12.18,12.399 10.347,13.422C8.797,14.287 7.399,15.264 6.417,16C7.399,16.736 8.797,17.713 10.347,18.578C12.18,19.601 14.224,20.5 16,20.5C17.776,20.5 19.82,19.601 21.653,18.578C23.203,17.713 24.601,16.736 25.583,16Z" />
        </g>
        <g transform="matrix(1,0,0,0.774436,0,3.60902)">
          <circle cx="16" cy="16" r="3.5" />
        </g>
      </g>
    </svg>
    """
  end

  def hide_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
      class={"h-6 w-6 p-1 inline mb-1 mr-1 stroke-none fill-current #{@class}"}
    >
      <g transform="matrix(1,0,0,1.26667,0,-4.26667)">
        <g transform="matrix(1,0,0,0.789474,0,3.36842)">
          <path d="M19.43,15.314C19.476,15.536 19.5,15.765 19.5,16C19.5,17.895 17.932,19.433 16,19.433C15.702,19.433 15.413,19.397 15.136,19.328L19.43,15.314ZM12.514,16.304C12.505,16.204 12.5,16.102 12.5,16C12.5,14.105 14.068,12.567 16,12.567C16.162,12.567 16.322,12.577 16.478,12.598L12.514,16.304Z" />
        </g>
        <g transform="matrix(1,0,0,0.789474,0,3.36842)">
          <path d="M25.196,9.924L22.343,12.591C23.899,13.75 25.296,15.026 26.293,16C25.238,17.03 23.737,18.398 22.072,19.609C20.103,21.041 17.908,22.3 16,22.3C15.013,22.3 13.948,21.963 12.878,21.439L9.838,24.281C11.9,25.576 14.079,26.5 16,26.5C18.389,26.5 21.177,25.071 23.642,23.277C26.923,20.89 29.627,17.938 29.912,17.623C29.952,17.579 29.991,17.533 30.028,17.485C30.137,17.344 30.227,17.186 30.298,17.018L30.314,16.98C30.438,16.676 30.499,16.343 30.5,16.011L30.5,15.989C30.499,15.657 30.438,15.324 30.314,15.02L30.298,14.982C30.227,14.814 30.137,14.656 30.028,14.515C29.991,14.467 29.952,14.421 29.912,14.377C29.673,14.114 27.742,12.004 25.196,9.924ZM6.557,21.872L9.399,19.215C7.947,18.109 6.649,16.92 5.707,16C6.762,14.97 8.263,13.602 9.928,12.391C11.897,10.959 14.092,9.7 16,9.7C16.892,9.7 17.848,9.975 18.813,10.415L21.882,7.546C19.904,6.343 17.834,5.5 16,5.5C13.611,5.5 10.823,6.929 8.358,8.723C5.077,11.11 2.373,14.062 2.088,14.377C2.048,14.421 2.009,14.467 1.972,14.515C1.863,14.656 1.773,14.814 1.702,14.982L1.686,15.02C1.562,15.324 1.501,15.657 1.5,15.989L1.5,16.011C1.501,16.343 1.562,16.676 1.686,16.98L1.702,17.018C1.773,17.186 1.863,17.344 1.972,17.485C2.009,17.533 2.048,17.579 2.088,17.623C2.319,17.878 4.133,19.86 6.557,21.872Z" />
        </g>
        <g transform="matrix(1,0,0,0.789474,0,3.36842)">
          <path d="M26.146,4.587L3.146,26.087C2.642,26.558 2.616,27.35 3.087,27.854C3.558,28.358 4.35,28.384 4.854,27.913L27.854,6.413C28.358,5.942 28.384,5.15 27.913,4.646C27.442,4.142 26.65,4.116 26.146,4.587Z" />
        </g>
      </g>
    </svg>
    """
  end

  def add_person_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linejoin:round;stroke-miterlimit:2;"
      class={"h-4 w-4 inline mb-1 mr-1 stroke-none fill-current #{@class}"}
    >
      <path d="M23.071,23.071L21.143,23.071C20.315,23.071 19.643,23.744 19.643,24.571C19.643,25.399 20.315,26.071 21.143,26.071L23.071,26.071L23.071,28C23.071,28.828 23.744,29.5 24.571,29.5C25.399,29.5 26.071,28.828 26.071,28L26.071,26.071L28,26.071C28.828,26.071 29.5,25.399 29.5,24.571C29.5,23.744 28.828,23.071 28,23.071L26.071,23.071L26.071,21.143C26.071,20.315 25.399,19.643 24.571,19.643C23.744,19.643 23.071,20.315 23.071,21.143L23.071,23.071Z" />
      <g transform="matrix(1,0,0,0.96,-3.09917e-11,0.782489)">
        <path d="M16,27.438L5.751,27.438C6.013,26.451 6.552,25.148 7.656,23.992C9.184,22.391 11.755,21.134 16,21.134C17.013,21.134 17.934,21.206 18.77,21.338C19.589,21.467 20.354,20.879 20.478,20.027C20.602,19.174 20.038,18.377 19.22,18.248C18.248,18.094 17.178,18.009 16,18.009C10.644,18.009 7.456,19.769 5.528,21.789C2.474,24.988 2.5,29 2.5,29C2.5,29.863 3.172,30.562 4,30.563L16,30.563C16.828,30.562 17.5,29.862 17.5,29C17.5,28.138 16.828,27.437 16,27.438Z" />
      </g>
      <g transform="matrix(1,0,0,0.96,-3.09917e-11,0.782489)">
        <path d="M16,2.438C11.844,2.438 8.5,5.844 8.5,10C8.5,14.156 11.844,17.563 16,17.563C20.156,17.563 23.5,14.156 23.5,10C23.5,5.844 20.156,2.438 16,2.438ZM16,5.563C18.467,5.563 20.5,7.533 20.5,10C20.5,12.467 18.467,14.437 16,14.437C13.533,14.437 11.5,12.467 11.5,10C11.5,7.533 13.533,5.563 16,5.563Z" />
      </g>
    </svg>
    """
  end

  def tick_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> nil end)

    ~H"""
    <svg
      width="100%"
      height="100%"
      viewBox="0 0 32 32"
      version="1.1"
      xmlns="http://www.w3.org/2000/svg"
      xmlns:xlink="http://www.w3.org/1999/xlink"
      xml:space="preserve"
      xmlns:serif="http://www.serif.com/"
      style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:1.5;"
      class={"h-4 w-4 stroke-none fill-current inline mb-1 mr-1 #{@class}"}
    >
      <g transform="matrix(2.01205,0,0,2.01205,-24.0972,-19.3546)">
        <path d="M13.329,18.305L18.329,22.876C18.536,23.066 18.813,23.159 19.093,23.133C19.372,23.106 19.627,22.964 19.795,22.739L26.652,13.596C26.982,13.158 26.892,12.534 26.454,12.205C26.015,11.876 25.391,11.965 25.062,12.404L18.862,20.67C18.862,20.67 14.671,16.838 14.671,16.838C14.266,16.468 13.637,16.496 13.266,16.901C12.896,17.306 12.924,17.935 13.329,18.305Z" />
      </g>
    </svg>
    """
  end
end
