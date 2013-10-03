defmodule Rex.Worker do

  use GenServer.Behaviour

  def start_link(config) do
    :gen_server.start_link(__MODULE__, config, [])
  end

  def init(config) do
    {:ok, pid} = :riakc_pb_socket.start_link(config[:host], config[:port])
    {:ok, pid}
  end

  def handle_call(:ping, _from, pid) do
    res = :riakc_pb_socket.ping(pid)
    {:reply, res, pid}
  end

  def handle_call({:put, bucket, key, value, options}, _from, pid) do
    obj = :riakc_obj.new(bucket, key, value)
    obj = set_secondary_indexes(obj, options)
    res = :riakc_pb_socket.put(pid, obj)
    {:reply, res, pid}
  end

  def handle_call({:get, bucket, key}, _from, pid) do
    case :riakc_pb_socket.get(pid, bucket, key) do
      {:ok, obj} -> res = :riakc_obj.get_value(obj)
      {:error, :notfound} -> res = {:error, :notfound}
    end
    {:reply, res, pid}
  end

  def handle_call({:get_index, bucket, index, query}, _from, pid) do
    res = :riakc_pb_socket.get_index(pid, bucket, index, query)
    {:reply, res, pid}
  end

  def handle_call({:delete, bucket, key}, _from, pid) do
    res = :riakc_pb_socket.delete(pid, bucket, key)
    {:reply, res, pid}
  end

  def handle_call({:search, bucket, query}, _from, pid) do
    res = :riakc_pb_socket.search(pid, bucket, query)
    {:reply, res, pid}
  end

  defp set_secondary_indexes(obj, options) do
    meta = :riakc_obj.get_update_metadata(obj)
    meta = :riakc_obj.set_secondary_index(meta, options)
    :riakc_obj.update_metadata(obj, meta)
  end

end
