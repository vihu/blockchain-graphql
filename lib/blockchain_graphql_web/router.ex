defmodule BlockchainGraphqlWeb.Router do
  use BlockchainGraphqlWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/" do
    pipe_through(:api)

    forward("/api", Absinthe.Plug, schema: BlockchainGraphqlWeb.Schema)

    forward(
      "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: BlockchainGraphqlWeb.Schema,
      interface: :simple
    )
  end

end
