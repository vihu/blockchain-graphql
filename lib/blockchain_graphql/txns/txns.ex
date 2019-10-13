defmodule BlockchainGraphql.Txns do

  alias BlockchainGraphql.Txn

  def list_txns(block) do
    block
    |> :blockchain_block.transactions()
    |> Enum.map(fn(t) ->
      txn(t)
    end)
  end

  defp txn(t) do
    %Txn{
      hash: :libp2p_crypto.bin_to_b58(:blockchain_txn.hash(t)),
      type: :blockchain_txn.type(t)
    }
  end
end
