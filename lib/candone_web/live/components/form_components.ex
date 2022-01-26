defmodule CandoneWeb.Components.FormComponents do
	import Phoenix.LiveView
  import Phoenix.LiveView.Helpers


  def radio_button(assigns) do
  	id = "#{assigns.f.id}_#{assigns.name}_#{assigns.value}"
  	name="#{assigns.f.name}[#{assigns.name}]"
  	value = Map.get(assigns.f.params, Atom.to_string(assigns.name)) || Map.get(assigns.f.data, assigns.name)

  	checked = "#{value}" == assigns.value

  	assigns = assigns
  						|> assign(:id, id)
  						|> assign(:name, name)
  						|> assign(:checked, checked)
  	~H"""
  		<div class="mr-6">
        <input
        	id={@id} 
        	type="radio" 
        	name={@name} 
        	value={@value}
        	checked={@checked}
        	class="appearance-none rounded-full h-4 w-4 border-2 border-gray-300 bg-white checked:bg-blue-600 checked:border-blue-600 focus:outline-none transition duration-200 mt-1 align-top bg-no-repeat bg-center bg-contain mr-2 cursor-pointer" />
        <label for={@name} class="inline-block text-gray-800"> <%= @label %> </label>
      </div>
  	"""

  end


end