defmodule GOTStats.GraphQL.Router do
  use GOTStats.GraphQL.Web, :router
  alias GOTStats.GraphQL.Schema

  pipeline :graphql do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :graphql

    forward "/graphql", Absinthe.Plug, schema: Schema

    if Mix.env == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL, schema: Schema
    end
  end
end
