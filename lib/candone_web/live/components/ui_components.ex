defmodule CandoneWeb.Components.UiComponents do
  import Phoenix.Component

  alias Phoenix.LiveView.JS

  import CandoneWeb.Components.Icons

  def add_button(assigns) do
    ~H"""
      <.live_patch_custom
        to={@to}
        class="new-issue-btn"
      >
        + Add <%= @name %>
      </.live_patch_custom>
    """
  end

  def add_project_button(assigns) do
    ~H"""
    <.live_patch_custom
        to={@to}
        class="new-issue-btn"
    >
      +
    </.live_patch_custom>
    """
  end

  def add_task_button(assigns) do
    ~H"""
    <.live_patch_custom
      to={@to}
      class="new-issue-btn"
    >
      + New Task
    </.live_patch_custom>
    """
  end

  def add_note_button(assigns) do
    ~H"""
    <.live_patch_custom
      to={@to}
      class="new-issue-btn"
    >
      + Add Note
    </.live_patch_custom>
    """
  end

  def add_person_button(assigns) do
    ~H"""
    <.live_patch_custom
      to={@to}
      class="new-issue-btn"
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
      <.link patch={@return_to} class="cursor-pointer filter-btn font-semibold">Cancel</.link>
    """
  end

  def hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  def dropdown_menu(assigns) do
    ~H"""
      <div class="group relative font-medium py-1 text-sm" style="color: #3d3d4a;">
        <button class="filter-btn">
          <%= @title %>
          <.arrow_down_icon class="!h-3 !w-3" />
        </button>
        <ul class="invisible group-hover:visible absolute z-50 mt-1 w-full min-w-[14rem] rounded-lg border py-1 text-sm shadow-lg overflow-auto focus:outline-none" style="background: #faf7f2; border-color: #e2ded6;">
          <%= for item <- @items do %>
            <li class="cursor-pointer select-none relative py-2 pl-3 pr-9" style="color: #3d3d4a; transition: background 0.15s;" onmouseenter="this.style.background='#f0ece4'" onmouseleave="this.style.background='transparent'">
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
      <div class="group relative font-medium py-1 text-sm">
        <button class="filter-btn">
          <span style="font-size: 12px;">↕</span>
          <%= @title %>
          <.arrow_down_icon class="!h-3 !w-3" />
        </button>
        <ul class="invisible group-hover:visible absolute z-50 mt-1 w-full min-w-[14rem] rounded-lg border py-1 text-sm shadow-lg overflow-auto focus:outline-none" style="background: #faf7f2; border-color: #e2ded6;">
          <%= render_slot(@inner_block) %>
        </ul>
      </div>
    """
  end

  def dropdown_menu_item(assigns) do
    ~H"""
      <li phx-click={@click} class="cursor-pointer select-none relative py-2 pl-3 pr-9" style="color: #3d3d4a; transition: background 0.15s;" onmouseenter="this.style.background='#f0ece4'" onmouseleave="this.style.background='transparent'">
        <span style="display: flex; align-items: center; gap: 6px;">
          <%= render_slot(@inner_block) %>
        </span>
      </li>
    """
  end

end
