defmodule CandoneWeb.Components.SelectComponent do
  use CandoneWeb, :live_component

  @impl true
  def update(assigns, socket) do
    %{f: f, name: name, options: options} = assigns

    # IO.inspect(f)

    value = Map.get(f.params, "#{name}") || Map.get(f.data, name)
    selected_option = Enum.find(options, & "#{&1.id}" == "#{value}") || List.first(options)

    {:ok,
      socket
      |> assign(assigns)
      |> assign(:selected_option, selected_option)
    }
  end

  @impl true
  def handle_event("update", %{"selectedIdx" => idx, "id" => id}, socket) do
    selected_option = Enum.at(socket.assigns.options, idx)

    {
      :noreply,
      socket
      |> push_event("close-selected", %{id: id, value: selected_option.name, value_id: selected_option.id})
      |> assign(:selected_option, selected_option)
    }
  end

end
