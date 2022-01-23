#test_component.ex
defmodule CandoneWeb.Components.TestComponent do
	use CandoneWeb, :live_component

	@impl true
	def update(assigns, socket) do

		IO.inspect(assigns, label: "UPDATE/assigns")
		%{name: name, options: options} = assigns
		left_options = Enum.map(options, & &1)
		right_options = []

		{:ok,
      		socket
      		|> assign(assigns)
      		|> assign(:left_options, left_options)
      		|> assign(:right_options, right_options)
  		}
	end

	@impl true
	def handle_event("update", %{"selectedIdx" => idx, "id" => id}, socket) do
		selected_options = Enum.concat(socket.assigns.selected_options, [Enum.find(socket.assigns.options, & &1.id == idx)])
		# remove idx from options
   		left_options = Enum.filter(socket.assigns.left_options, & &1.id != idx)

   		{:ok,
   			socket
   			|> assign(:left_options, left_options)
   			|> assign(:selected_options, selected_options)
   		}
	end

	def handle_event("select-left", %{"option-id" => option_id}, socket) do
		IO.inspect(socket, label: "SOCKET")
		right_option = Enum.find(socket.assigns.left_options, & "#{&1.id}" == option_id)
		IO.inspect(right_option, label: "RIGHT_OPTION")
		right_options = Enum.concat(socket.assigns.right_options, [right_option])
		left_options = Enum.filter(socket.assigns.left_options, & "#{&1.id}" != option_id)
		IO.inspect(left_options, label: "LEFT_OPTION")

		{:noreply, 
			socket
			|> assign(:left_options, left_options)
			|> assign(:right_options, right_options)
		}
	end

end