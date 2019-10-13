defmodule BlockchainGraphqlWeb.Resolvers.Block do

  def list_blocks(_parent, %{limit: limit}, _resolution) do
    {:ok, BlockchainGraphql.Blocks.list_blocks(limit)}
  end
  def list_blocks(_parent, _args, _resolution) do
    {:ok, BlockchainGraphql.Blocks.list_blocks()}
  end

end
