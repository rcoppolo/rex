defmodule Rex.Mixfile do

  use Mix.Project

  def project do
    [
      app: :rex,
      version: "0.0.2",
      elixir: "~> 0.11.2",
      deps: deps
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      registered: [ :rex ],
      mod: { Rex, [] },
      env: [
        riak: [
          size: 5,
          max_overflow: 10,
          host: '172.17.42.1',
          port: 10017
        ]
      ],
    ]
  end

  defp deps do
    [ { :poolboy, github: "devinus/poolboy" },
      { :riak_erlang_client, github: "basho/riak-erlang-client", app: false } ]
  end

end
