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
    get "/cards/:id", CardController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", Console do
  #   pipe_through :api
  # end
end
