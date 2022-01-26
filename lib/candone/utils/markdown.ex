defmodule Candone.Markdown do
	alias Earmark

	@class_map %{
		"h3" => "text-lg font-medium mb-2",
		"ul" => "list-disc list-inside leading-7",
		"ol" => "list-decimal list-inside leading-7",
		"li" => "",
		"strong" => "",
		"p" => "py-4",
		"a" => "text-blue-600 visited:text-purple-600"
	}

	def as_html(nil), do: ""

	def as_html(markdown) do
		markdown
		|> Earmark.as_ast!()
		|> Earmark.Transform.map_ast(fn {t, a, _, m} -> {t, a ++ [{"class", Map.get(@class_map, t, "")}], nil, m} end, true)
		|> Earmark.transform()
	end
end