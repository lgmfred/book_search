defmodule BookSearchWeb.Router do
  use BookSearchWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {BookSearchWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", BookSearchWeb do
    pipe_through(:browser)

    get("/", PageController, :index)

    # Routes for the AuthorController actions
    get "/authors", AuthorController, :index
    get "/authors/new", AuthorController, :new
    get "/authors/:id", AuthorController, :show
    get "/authors/edit/:id", AuthorController, :edit
    post "/authors", AuthorController, :create
    put "/authors/:id", AuthorController, :update
    patch "/authors/:id", AuthorController, :update
    delete "/authors/:id", AuthorController, :delete

    # Routes for the BookController actions
    get "/books", BookController, :index
    get "/books/new", BookController, :new
    get "/books/:id", BookController, :show
    get "/books/edit/:id", BookController, :edit
    post "/books", BookController, :create
    put "/books/:id", BookController, :update
    patch "/books/:id", BookController, :update
    delete "/books/:id", BookController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", BookSearchWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: BookSearchWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
