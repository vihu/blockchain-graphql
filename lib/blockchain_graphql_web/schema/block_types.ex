defmodule BlockchainGraphqlWeb.Schema.BlockTypes do
  use Absinthe.Schema.Notation

  @desc "A block"
  object :block do
    field :height, :integer
    field :time, :integer
    field :hash, :string
  end

end
