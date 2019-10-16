defmodule BlockchainGraphql.MixProject do
  use Mix.Project

  def project do
    [
      app: :blockchain_graphql,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {BlockchainGraphql.Application, []},
      included_applications: [:blockchain],
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [

      # phoenix deps
      {:phoenix, "~> 1.4.10"},
      {:phoenix_pubsub, "~> 1.1"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},


      # blockcahin specific deps
      {:ranch, "~> 1.7.1", override: true},
      {:blockchain, git: "git@github.com:helium/blockchain-core.git", branch: "master"},
      {:cuttlefish, git: "https://github.com/helium/cuttlefish.git", branch: "develop", override: true},
      {:lager, "3.6.7", [env: :prod, repo: "hexpm", hex: "lager", override: true, manager: :rebar3]},
      {:h3, git: "https://github.com/helium/erlang-h3.git", branch: "master"},

      # graphql deps
      {:absinthe_plug, "~> 1.4"},
      {:absinthe, "~> 1.4"}
    ]
  end
end
