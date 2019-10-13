defmodule BlockchainGraphql.Blocks do

  alias BlockchainGraphql.Block

  def list_blocks(limit) do
    chain = :blockchain_worker.blockchain()
    with {:ok, current} <- :blockchain.height(chain) do

      Range.new(current - limit, current)
      |> Enum.reduce([],
        fn(i, acc) ->
          {:ok, b} = :blockchain.get_block(i, chain)
          [ block(b) | acc]
        end)

    else
      []
    end
  end
  def list_blocks do
    chain = :blockchain_worker.blockchain()
    with {:ok, _current} <- :blockchain.height(chain) do

      chain
      |> :blockchain.blocks()
      |> Enum.reduce([],
        fn({_hash, b}, acc) ->
          [ block(b) | acc]
        end)
      |> Enum.sort_by(fn(b) -> b.height end)
      |> Enum.reverse()

    else
      []
    end
  end

  defp block(block) do
    %Block{
      height: :blockchain_block.height(block),
      time: :blockchain_block.time(block),
      hash: :libp2p_crypto.bin_to_b58(:blockchain_block.hash_block(block))
    }
  end

end
