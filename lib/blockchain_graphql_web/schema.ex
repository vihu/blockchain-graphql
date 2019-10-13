defmodule BlockchainGraphqlWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom
  import_types BlockchainGraphqlWeb.Schema.BlockTypes
  import_types BlockchainGraphqlWeb.Schema.TxnTypes

  alias BlockchainGraphqlWeb.Resolvers

  query do

    @desc "Get all blocks"
    field :blocks, list_of(:block) do
      arg :limit, :integer
      resolve &Resolvers.Block.list_blocks/3
    end

  end

end
