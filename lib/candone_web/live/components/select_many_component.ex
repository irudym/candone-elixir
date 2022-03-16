defmodule CandoneWeb.Components.SelectManyComponent do
  use CandoneWeb, :live_component


  def mount(_params, _session, socket) do
    {:ok, socket
          |> assign(filtered_options: [])}
  end

  @impl true
  def update(assigns, socket) do
    %{f: f, name: name, options: options, id: id} = assigns

    IO.inspect(f, label: "UPDATE/f")

    # get stored values of options ids
    value = Map.get(f.params, "#{name}")
    values_ids = if value && value != "" do
      String.split(value, ",")
    else
      Map.get(f.data, name)
    end


    selected_options = Enum.map(values_ids, fn id -> Enum.find(options, & "#{&1.id}" == "#{id}") end)
    available_options = Enum.filter(options, fn val_id -> !Enum.find(selected_options, & "#{&1.id}" == "#{val_id.id}") end)

    # available_ids = Enum.map(filtered_options, & &1.id)

    {:ok,
      socket
      |> push_event("close-selected", %{id: id, value: selected_options})
      |> assign(assigns)
      |> assign(:selected_options, selected_options)
      |> assign(:available_options, available_options)
      |> assign(:filtered_ids, Enum.join(values_ids,","))
    }
  end

  @impl true
  def handle_event("update", %{"selectedIdx" => idx, "id" => id}, socket) do

    IO.inspect(socket, label: "HANDLE UPDATE/socket")


    selected_options = Enum.concat(socket.assigns.selected_options, [Enum.find(socket.assigns.options, & "#{&1.id}" == "#{idx}")])

    # remove idx from options
    filtered_options = Enum.filter(socket.assigns.filtered_options, & "#{&1.id}" != "#{idx}")
    available_ids = Enum.map(filtered_options, & &1.id)

    IO.inspect(filtered_options, label: "HANDLE UPDATE/filtered_options")
    IO.inspect(available_ids, label: "HANDLE UPDATE/available_ids")
    {
      :noreply,
      socket
      |> push_event("close-selected", %{id: id, value: selected_options})
      |> assign(:selected_options, selected_options)
      |> assign(:filtered_options, filtered_options)
      |> assign(:filtered_ids, Enum.join(available_ids, ","))
    }
  end

  def handle_event("remove", %{"selectedIdx" => idx, "id" => id}, socket) do
    # remove the option from selected options
    selected_options = Enum.filter(socket.assigns.selected_options,& "#{&1.id}" != "#{idx}")

    # return the option to available list
    filtered_options = Enum.filter(socket.assigns.options, fn val_id -> !Enum.find(selected_options, & "#{&1.id}" == "#{val_id.id}") end)

    # available_options = [Enum.find(socket.assigns.options, & "#{&1.id}" == "#{idx}") | socket.assigns.filtered_options]
    available_ids = Enum.map(filtered_options, & &1.id)

    {
      :noreply,
      socket
      |> push_event("close-selected", %{id: id, value: selected_options})
      |> assign(:selected_options, selected_options)
      |> assign(:filtered_options, filtered_options)
      |> assign(:filtered_ids, available_ids)
    }
  end

  def handle_event("search-input", %{"value" => text}, socket) do
    IO.inspect(text, label: "Search-Input:Params")

    available_options = Enum.filter(socket.assigns.options, fn val_id -> !Enum.find(socket.assigns.selected_options, & "#{&1.id}" == "#{val_id.id}") end)
    filtered_options = Enum.filter(available_options, fn el -> String.contains?(el.name, text) end)
    available_ids = Enum.map(filtered_options, & &1.id)

    {:noreply,
              socket
              |> assign(:filtered_options, filtered_options)
              |> assign(:filtered_ids, available_ids)
    }
  end

end
