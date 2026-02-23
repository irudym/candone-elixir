defmodule CandoneWeb.Components.CardComponents do
  import Phoenix.Component

  import CandoneWeb.Components.Icons

  @urgency_classes %{
    0 => "urgency-0",
    1 => "urgency-1",
    2 => "urgency-2",
    3 => "urgency-3"
  }

  @urgency_icons %{
    0 => "○",
    1 => "◉",
    2 => "◉",
    3 => "◉"
  }

  defp urgency_class(urgency), do: Map.get(@urgency_classes, urgency, "urgency-0")
  defp urgency_icon(urgency), do: Map.get(@urgency_icons, urgency, "○")

  def project_card(assigns) do
    assigns = assign_new(assigns, :target, fn -> nil end)

    ~H"""
    <div
      class={"sidebar-nav-item project-item group #{if assigns.selected, do: "project-item-active"}"}
      phx-click={"#{@type}-select"}
      phx-value-id={@value}
      phx-target={@target}
      id={"#{@type}-#{@value}"}
    >
      <span style="font-size: 11px; width: 20px; text-align: left;">
        <span class="nav-count"><%= @tasks %></span>
      </span>
      <span style="flex: 1;"><%= @name %></span>
      <div style="display: flex; align-items: center; gap: 8px;">
        <!-- Delete button on hover -->
        <div class="invisible group-hover:visible">
          <.delete_button_icon type={@type} value={@value} target={@target} />
        </div>
      </div>
    </div>
    """
  end

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

  def card(assigns) do
    urgency = Map.get(assigns, :urgency, 0)
    assigns = assign(assigns, :urgency_class, urgency_class(urgency))
    assigns = assign(assigns, :urgency_icon, urgency_icon(urgency))

    ~H"""
    <div class="task-card group" phx-click={@click} phx-value-id={@value} id={"#{@type}-#{@value}"}>
      <!-- Top row: priority icon + task ID -->
      <div style="display: flex; align-items: center; gap: 8px; margin-bottom: 6px;">
        <span class={@urgency_class} style="font-size: 13px;"><%= @urgency_icon %></span>
        <span style="font-size: 11.5px; color: #a5a5b0; font-weight: 500;">
          TSK-<%= @value %>
        </span>
      </div>
      <!-- Title -->
      <div style={"font-size: 13px; color: #3d3d4a; font-weight: 500; line-height: 1.5; margin-bottom: 10px; #{if Map.get(assigns, :disabled, nil), do: "color: #b0b0be;", else: ""}"}>
        <%= @name %>
      </div>
      <!-- Bottom row: info badges + people + delete -->
      <div style="display: flex; align-items: center; justify-content: space-between; gap: 8px;">
        <div style="display: flex; flex-wrap: wrap; gap: 5px;">
          <%= if @counter2 && @counter2 != "0" && @counter2 != 0 do %>
            <span class="subtask-badge">
              Cost: <%= @counter2 %>
            </span>
          <% end %>
        </div>
        <div style="display: flex; align-items: center; gap: 8px;">
          <%= if @counter1 && @counter1 != 0 do %>
            <span class="subtask-badge">
              <.people_icon class="!h-3 !w-3 !p-0" /> <%= @counter1 %>
            </span>
          <% end %>
          <!-- Delete icon on hover -->
          <div class="invisible group-hover:visible">
            <.delete_button_icon type={@type} value={@value} />
          </div>
        </div>
      </div>
    </div>
    """
  end
end
