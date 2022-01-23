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
          <div
            id="modal-content"
            class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4 rounded-lg"
            phx-window-keydown={JS.dispatch("click", to: "#close")}
            phx-key="escape"
          >
            <%= if @return_to do %>
              <%= live_patch "✖",
                to: @return_to,
                id: "close",
                class: "phx-modal-close",
                phx_click: hide_modal()
              %>
            <% else %>
             <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
            <% end %>

            <div class="p-6 space-y-6">
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
