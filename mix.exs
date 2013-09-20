defmodule Rex.Mixfile do

  use Mix.Project

  def project do
    [
      app: :rex,
      version: "0.0.1",
      elixir: "~> 0.10.3-dev",
      deps: deps
    ]
  end

  # Configuration for the OTP application
  def application do
    [
      registered: [:rex],
      mod: { Rex, [] },
      env: [dev: [port: 10017, host: '172.17.42.1']],
    ]
  end

  defp deps do
    [
      { :poolboy, github: "devinus/poolboy" },
      { :riak_erlang_client, github: "basho/riak-erlang-client", app: false }
    ]
  end

end
