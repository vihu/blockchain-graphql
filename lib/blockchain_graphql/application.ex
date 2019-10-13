defmodule BlockchainGraphql.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    base_dir = Application.get_env(:blockchain, :base_dir, String.to_charlist("data"))
    swarm_key = to_charlist(:filename.join([base_dir, "blockchain_graphql", "swarm_key"]))
    :ok = :filelib.ensure_dir(swarm_key)

    {pubkey, ecdh_fun, sig_fun} =
      case :libp2p_crypto.load_keys(swarm_key) do
        {:ok, %{:secret => priv_key, :public => pub_key}} ->
          {pub_key, :libp2p_crypto.mk_ecdh_fun(priv_key), :libp2p_crypto.mk_sig_fun(priv_key)}

        {:error, :enoent} ->
          key_map =
            %{:secret => priv_key, :public => pub_key} =
            :libp2p_crypto.generate_keys(:ecc_compact)

          :ok = :libp2p_crypto.save_keys(key_map, swarm_key)
          {pub_key, :libp2p_crypto.mk_ecdh_fun(priv_key), :libp2p_crypto.mk_sig_fun(priv_key)}
      end

    seed_nodes = Application.get_env(:blockchain, :seed_nodes, [])
    seed_node_dns = Application.get_env(:blockchain, :seed_node_dns, '')
    seed_addresses = dns_to_addresses(seed_node_dns)

    blockchain_sup_opts = [
      {:key, {pubkey, sig_fun, ecdh_fun}},
      {:seed_nodes, seed_nodes ++ seed_addresses},
      {:port, 0},
      {:base_dir, base_dir},
      {:libp2p_proxy, [{:limit, 0}]}
    ]

    children = [
      %{
        id: :blockchain_sup,
        start: {:blockchain_sup, :start_link, [blockchain_sup_opts]},
        restart: :permanent,
        type: :supervisor
      },
      {BlockchainGraphql.Worker, [%{}]},
      BlockchainGraphqlWeb.Endpoint,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BlockchainGraphql.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BlockchainGraphqlWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp dns_to_addresses(seed_node_dns) do
    List.flatten(
      for x <- :inet_res.lookup(seed_node_dns, :in, :txt),
          String.starts_with?(to_string(x), "blockchain-seed-nodes="),
          do: String.trim_leading(to_string(x), "blockchain-seed-nodes=")
    )
    |> List.to_string()
    |> String.split(",")
    |> Enum.map(&String.to_charlist/1)
  end
end
