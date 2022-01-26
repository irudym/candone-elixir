# Candone

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


## Useful links
https://pragmaticstudio.com/tutorials/adding-tailwind-css-to-phoenix



## Model definitions


### Tasks
Model which handles all information about a task. Many tasks might be associated with many projects, for example one task could be relate to two projects. Main fields are follwoing. 

  * **name**:string - Task name or title
  * **description**:text - Task description
  * **cost**:integer - The estimated cost (number of hours, resources cost and so on) to complete the task
  * **urgency**:integer - The task urgency, could be 0 - no urgency, 1 - low, 2 - medium, 3 - high
  * **stage**:integer - The task stage, could be 0 - in backlog, 1 - in spring (working on it), 2 - done
  * **people**:associations - The list of people which are responsible for the task 
  * **projects**:associations - Lnked projects, by design one task could be linked to many projects
   