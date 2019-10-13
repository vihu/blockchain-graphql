defmodule BlockchainGraphqlWeb.Schema.TxnTypes do
  use Absinthe.Schema.Notation

  @desc "A generic txn"
  object :txn do
    field :type, non_null(:string)
    field :hash, non_null(:string)
  end

end
