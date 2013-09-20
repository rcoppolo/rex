defmodule Rex.Server do

  use GenServer.Behaviour

  def start_link() do
    :gen_server.start_link({:local, __MODULE__}, __MODULE__, [], [])
  end

  def ping() do
    :gen_server.call(__MODULE__, :ping)
  end

  def init([]) do
    {:ok, config} = :application.get_env(:rex, :dev)
    {:ok, riak} = :riakc_pb_socket.start_link(config[:host], config[:port])
    {:ok, riak}
  end

  def handle_call(:ping, _from, riak) do
    resp = :riakc_pb_socket.ping(riak)
    {:reply, resp, riak}
  end

end
