defmodule Console.Router do
  use Console, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Console do
    pipe_through :browser

    get "/", PageController, :index

    get "/cards", CardController, :index
    post "/cards", CardController, :create
    get "/cards/card/:id", CardController, :show
    get "/cards/card/:id/edit", CardController, :edit
    patch "/cards/card/:id", CardController, :update
    delete "/cards/card/:id", CardController, :delete
    get "/cards/new", CardController, :new
  end

  # Other scopes may use custom stacks.
  # scope "/api", Console do
  #   pipe_through :api
  # end
end
