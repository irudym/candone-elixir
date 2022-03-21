defmodule CandoneWeb.Components.SelectManyComponent do
  use CandoneWeb, :live_component


  def mount(_params, _session, socket) do
    # IO.inspect(socket, label: "SELECT_MANY/mount/socket: ")
    {:ok, socket
          |> assign(filtered_options: [])}
  end

  @impl true
  def update(assigns, socket) do
    %{f: f, name: name, options: options, id: id} = assigns

    # get stored values of options ids
    value = Map.get(f.params, "#{name}")
    values_ids = if value && value != "" do
      String.split(value, ",")
    else
      Map.get(f.data, name)
    end

    selected_options = Enum.map(values_ids, fn id -> Enum.find(options, & "#{&1.id}" == "#{id}") end)
    available_options = Enum.filter(options, fn val_id -> !Enum.find(selected_options, & "#{&1.id}" == "#{val_id.id}") end)

    {:ok,
      socket
      |> assign(assigns)
      |> assign(:selected_options, selected_options)
      |> assign(:filtered_options, available_options)
      |> assign(:filtered_ids, Enum.join(values_ids,","))
      |> push_event("update_input", %{id: id, input_id: "#{f.id}_#{name}", value: values_ids})
    }
  end

  @impl true
  def handle_event("select", %{"id" => id}, socket) do
    %{selected_options: selected_options, filtered_options: filtered_options} = socket.assigns

    option = Enum.find(filtered_options, & "#{&1.id}" == "#{id}")
    selected_options = Enum.concat(selected_options, [option])

    filtered_options = Enum.reject(filtered_options, & "#{&1.id}" == "#{id}")

    {:noreply,
        socket
        |> assign(:selected_options, selected_options)
        |> assign(:filtered_options, filtered_options)
        |> push_update_event(selected_options)
    }
  end

  defp push_update_event(socket, selected_options) do
    %{f: f, name: name} = socket.assigns
    values_ids = Enum.map(selected_options, & &1.id)

    push_event(socket, "update_input", %{id: socket.assigns.id, input_id: "#{f.id}_#{name}", value: values_ids})
  end

  @impl true
  def handle_event("remove", %{"id" => id}, socket) do
    %{selected_options: selected_options, filtered_options: filtered_options} = socket.assigns

    option = Enum.find(selected_options, & "#{&1.id}" == "#{id}")
    filtered_options = [option | filtered_options]
    selected_options = Enum.reject(selected_options, & "#{&1.id}" == "#{id}")

    {:noreply,
        socket
        |> assign(:selected_options, selected_options)
        |> assign(:filtered_options, filtered_options)
        |> push_update_event(selected_options)
    }
  end

  @impl true
  def handle_event("search", %{"value" => value}, socket) do
    %{selected_options: selected_options, options: options} = socket.assigns

    available_options = Enum.filter(options, fn val_id -> !Enum.find(selected_options, & "#{&1.id}" == "#{val_id.id}") end)
    filtered_options = Enum.filter(available_options, & String.contains?(&1.name, value))

    {:noreply,
        socket
        |> assign(:filtered_options, filtered_options)
    }
  end

end
