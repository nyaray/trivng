defmodule TrivWeb.Router do
  use TrivWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    # Not used
    # plug :fetch_flash
    # plug :protect_from_forgery
    # plug :put_secure_browser_headers
  end

  scope "/api", TrivWeb do
    pipe_through :api

    post "/", ApiController, :process
    match(:*, "/echo", ApiController, :echo)
    match(:*, "/", ApiController, :bad_method)
    match(:*, "/*any", ApiController, :not_found)
  end

  scope "/", TrivWeb do
    pipe_through :browser
    get "/", PageController, :index
    match :*, "/*any", PageController, :not_found
  end
end
