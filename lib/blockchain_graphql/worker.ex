defmodule BlockchainGraphql.Worker do
  use GenServer
  @me __MODULE__
  @app :blockchain_graphql

  require Logger

  def start_link(args) do
    GenServer.start_link(@me, args, name: @me)
  end

  @impl true
  def init(args) do
    Process.flag(:trap_exit, true)

    @app
    |> :code.priv_dir()
    |> Path.join("genesis")
    |> File.read!()
    |> :blockchain_block.deserialize()
    |> :blockchain_worker.integrate_genesis_block()

    Logger.info("#{inspect(@me)} init with #{inspect(args)}")

    {:ok, args}
  end

  @impl true
  def handle_call(msg, from, state) do
    Logger.warn("unknown call, msg: #{inspect(msg)}, from: #{inspect(from)}")
    {:reply, :ok, state}
  end

  @impl true
  def handle_cast(msg, state) do
    Logger.warn("unknown cast, msg: #{inspect(msg)}")
    {:noreply, state}
  end
end
