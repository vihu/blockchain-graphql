defmodule BlockchainGraphqlWeb.Schema.BlockTypes do
  use Absinthe.Schema.Notation

  # alias BlockchainGraphqlWeb.Resolvers

  @desc "A block"
  object :block do
    field :height, :integer
    field :time, :integer
    field :hash, :string
    field :txns, list_of(:txn)
  end

end
