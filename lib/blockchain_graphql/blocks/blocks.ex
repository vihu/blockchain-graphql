defmodule BlockchainGraphql.Blocks do

  alias BlockchainGraphql.Block
  @default_limit 500

  def list_blocks(limit) do
    list_blocks_(limit)
  end
  def list_blocks do
    list_blocks_(@default_limit)
  end

  defp block(block) do
    %Block{
      height: :blockchain_block.height(block),
      time: :blockchain_block.time(block),
      hash: :libp2p_crypto.bin_to_b58(:blockchain_block.hash_block(block)),
      txns: length(:blockchain_block.transactions(block))
    }
  end

  defp list_blocks_(limit) do
    chain = :blockchain_worker.blockchain()
    with {:ok, current} <- :blockchain.height(chain) do

      Range.new(current - limit + 1, current)
      |> IO.inspect()
      |> Enum.reduce([],
        fn(i, acc) ->
          {:ok, b} = :blockchain.get_block(i, chain)
          [ block(b) | acc]
        end)

    else
      []
    end
  end
end
