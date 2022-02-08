defmodule CandoneWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.company_index_path(@socket, :index)}>
        <.live_component
          module={CandoneWeb.CompanyLive.FormComponent}
          id={@company.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.company_index_path(@socket, :index)}
          company: @company
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="fixed z-10 inset-0 overflow-y-auto" phx-remove={hide_modal()}>
      <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">>
        <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>

        <!-- This element is to trick the browser into centering the modal contents. -->
        <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

        <div class="inline-block align-bottom bg-white text-left rounded-lg shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">
          <!-- modal header -->
          <div class="absolute w-full -top-0.5 left-0 h-12 bg-primary-300 rounded-t-lg">
            <div class="relative flex flex-row-reverse justify-between items-center p-1 px-3">
              <%= if @return_to do %>
                  <a class="m-2 text-gray-100" href={@return_to} id="close" phx-click={hide_modal()}>
                    <svg
                    xmlns="http://www.w3.org/2000/svg"
                    class="mx-1 p-1 rounded-md w-5 h-5 cursor-pointer text-gray-100 stroke-current hover:bg-gray-300"
                    style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-miterlimit:2;"
                    fill="none"
                    viewBox="0 0 10 10"
                    stroke="currentColor"
                    width="100%" height="100%"
                    xml:space="preserve" xmlns:serif="http://www.serif.com/"
                    >
                      <g transform="matrix(0.646062,-0.149612,-0.148781,0.649668,-0.319038,-1.14623)">
                        <path d="M3,4L18.991,19.991" style="fill:none;stroke-width:3.2px;"/>
                      </g>
                      <g transform="matrix(0.148781,0.649668,-0.646062,-0.149612,11.1139,-0.350554)">
                          <path d="M3,4L18.991,19.991" style="fill:none;stroke-width:3.2px;stroke-linejoin:round;stroke-miterlimit:1.5;"/>
                      </g>
                    </svg>
                  </a>
                <% else %>
                  <a id="close" href="#" class="m-2 text-gray-100" phx-click={hide_modal()}>
                  <svg
                  xmlns="http://www.w3.org/2000/svg"
                  class="mx-1 p-1 rounded-md w-5 h-5 cursor-pointer text-gray-100 stroke-current hover:bg-gray-300"
                  style="fill-rule:evenodd;clip-rule:evenodd;stroke-linecap:round;stroke-miterlimit:2;"
                  fill="none"
                  viewBox="0 0 10 10"
                  stroke="currentColor"
                  width="100%" height="100%"
                  xml:space="preserve" xmlns:serif="http://www.serif.com/"
                  >
                    <g transform="matrix(0.646062,-0.149612,-0.148781,0.649668,-0.319038,-1.14623)">
                      <path d="M3,4L18.991,19.991" style="fill:none;stroke-width:3.2px;"/>
                    </g>
                    <g transform="matrix(0.148781,0.649668,-0.646062,-0.149612,11.1139,-0.350554)">
                        <path d="M3,4L18.991,19.991" style="fill:none;stroke-width:3.2px;stroke-linejoin:round;stroke-miterlimit:1.5;"/>
                    </g>
                  </svg>
                  </a>
              <% end %>
              <div class="font-medium text-gray-100 text-base pl-4">
                <%= @title %>
              </div>
            </div>
          </div>
          <div
            id="modal-content"
            class="bg-white px-1 pt-5 pb-4 sm:p-6 sm:pb-4 rounded-lg"
            phx-window-keydown={JS.dispatch("click", to: "#close")}
            phx-key="escape"
          >
            <div class="p-1 pt-14 space-y-6">
              <%= render_slot(@inner_block) %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
