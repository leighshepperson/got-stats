defmodule GOTStats.GraphQL.Router do
  use GOTStats.GraphQL.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GOTStats.GraphQL do
    pipe_through :api
  end
end
