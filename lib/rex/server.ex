defmodule Rex.Server do

  use GenServer.Behaviour

  def start_link() do
    :gen_server.start_link({:local, __MODULE__}, __MODULE__, [], [])
  end

  def ping() do
    :gen_server.call(__MODULE__, :ping)
  end

  def put(bucket, key, value) do
    :gen_server.call(__MODULE__, {:put, bucket, key, value})
  end

  def get(bucket, key) do
    :gen_server.call(__MODULE__, {:get, bucket, key})
  end

  def init([]) do
    {:ok, config} = :application.get_env(:rex, :dev)
    {:ok, pid} = :riakc_pb_socket.start_link(config[:host], config[:port])
    {:ok, pid}
  end

  def handle_call(:ping, _from, pid) do
    resp = :riakc_pb_socket.ping(pid)
    {:reply, resp, pid}
  end

  def handle_call({:put, bucket, key, value}, _from, pid) do
    obj = :riakc_obj.new(bucket, key, value)
    resp = :riakc_pb_socket.put(pid, obj)
    {:reply, resp, pid}
  end

  def handle_call({:get, bucket, key}, _from, pid) do
    {:ok, obj} = :riakc_pb_socket.get(pid, bucket, key)
    resp = :riakc_obj.get_value(obj)
    {:reply, resp, pid}
  end

end
