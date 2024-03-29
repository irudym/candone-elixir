defmodule CandoneWeb.Router do
  use CandoneWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CandoneWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CandoneWeb do
    pipe_through :browser

    live "/", DashboardLive.Index, :index
    live "/dashboard/projects/new", DashboardLive.Index, :new_project
    live "/dashboard/projects/:id", DashboardLive.Index, :show_project
    live "/dashboard/tasks/new", DashboardLive.Index, :new_task
    live "/dashboard/tasks/:id/edit", DashboardLive.Index, :edit_task
    live "/dashboard/notes/new", DashboardLive.Index, :new_note
    live "/dashboard/notes/:id/edit", DashboardLive.Index, :edit_note


    live "/companies", CompanyLive.Index, :index
    live "/companies/new", CompanyLive.Index, :new
    live "/companies/:id/edit", CompanyLive.Index, :edit
    live "/companies/:id", CompanyLive.Show, :show
    live "/companies/:id/show/edit", CompanyLive.Show, :edit

    live "/people", PersonLive.Index, :index
    live "/people/new", PersonLive.Index, :new
    live "/people/:id/edit", PersonLive.Index, :edit
    live "/people/:id", PersonLive.Show, :show
    live "/people/:id/show/edit", PersonLive.Show, :edit

    live "/projects", ProjectLive.Index, :index
    live "/projects/new", ProjectLive.Index, :new
    live "/projects/:id/edit", ProjectLive.Index, :edit
    live "/projects/:id", ProjectLive.Show, :show
    live "/projects/:id/show/edit", ProjectLive.Show, :edit

    live "/tasks", TaskLive.Index, :index
    live "/tasks/new", TaskLive.Index, :new
    live "/tasks/:id/edit", TaskLive.Index, :edit
    live "/tasks/:id", TaskLive.Show, :show
    live "/tasks/:id/show/edit", TaskLive.Show, :edit

    live "/notes", NoteLive.Index, :index
    live "/notes/new", NoteLive.Index, :new
    live "/notes/:id/edit", NoteLive.Index, :edit
    live "/notes/:id", NoteLive.Show, :show
    live "/notes/:id/show/edit", NoteLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", CandoneWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:candone, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CandoneWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
