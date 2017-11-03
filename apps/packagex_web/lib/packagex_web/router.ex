defmodule PackagexWeb.Router do
  use PackagexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipe_through :api

  resources "/packages", PackagexWeb.PackagesController, only: [:create, :show, :update, :delete, :index]
end

