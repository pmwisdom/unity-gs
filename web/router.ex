defmodule UnityGs.Router do
  use UnityGs.Web, :router

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

  scope "/api", UnityGs do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/", UnityGs do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", UnityGs do
  #   pipe_through :api
  # end
end
