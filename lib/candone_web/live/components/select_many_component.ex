defmodule CandoneWeb.Components.SelectManyComponent do
  use CandoneWeb, :live_component


  def mount(_params, _session, socket) do 
    available_options = []
    {:ok, socket
          |> assign(available_options: available_options)}
  end

  @impl true
  def update(assigns, socket) do
    %{f: f, name: name, options: options, id: id} = assigns

    # IO.inspect(f, label: "SelectManyComponent/UPDATE/f")
    
    value = Map.get(f.params, "#{name}")
    # IO.inspect(value, label: "UPDATE/value")
    
    values_ids = if value && value != "" do
      String.split(value, ",")
    else
      Map.get(f.data, name)
    end

    
    # IO.inspect(options, label: "SelectManyComponent/options")
    # IO.inspect(values_ids, label: "SelectManyComponent/values_ids")
    
    selected_options = Enum.map(values_ids, fn id -> Enum.find(options, & "#{&1.id}" == "#{id}") end)  
    #IO.inspect(selected_options, label: "UPDATE/selected_options")

    available_options = Enum.filter(options, fn val_id -> !Enum.find(selected_options, & "#{&1.id}" == "#{val_id.id}") end)
    #IO.inspect(available_options, label: "UPDATE/available_options")

    {:ok,
      socket
      |> push_event("close-selected", %{id: id, value: selected_options})
      |> assign(assigns)
      |> assign(:selected_options, selected_options)
      |> assign(:available_options, available_options)
    }
  end

  @impl true
  def handle_event("update", %{"selectedIdx" => idx, "id" => id}, socket) do

    #IO.inspect(id, label: "HANDLE UPDATE")
    selected_options = Enum.concat(socket.assigns.selected_options, [Enum.find(socket.assigns.options, & "#{&1.id}" == "#{idx}")])

    # remove idx from options
    available_options = Enum.filter(socket.assigns.available_options, & "#{&1.id}" != "#{idx}")

    {
      :noreply,
      socket
      |> push_event("close-selected", %{id: id, value: selected_options})
      |> assign(:selected_options, selected_options)
      |> assign(:available_options, available_options)
    }
  end

  def handle_event("remove", %{"selectedIdx" => idx, "id" => id}, socket) do
    # remove the option from selected options
    selected_options = Enum.filter(socket.assigns.selected_options,& "#{&1.id}" != "#{idx}")

    # return the option to available list
    available_options = [Enum.find(socket.assigns.options, & "#{&1.id}" == "#{idx}") | socket.assigns.available_options]

    {
      :noreply,
      socket
      |> push_event("close-selected", %{id: id, value: selected_options})
      |> assign(:selected_options, selected_options)
      |> assign(:available_options, available_options)
    }
  end

end