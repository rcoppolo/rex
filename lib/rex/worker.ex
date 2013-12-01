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

  def handle_call({:put, object}, _from, pid) do
    obj = :riakc_obj.new(object.bucket, object.key, object.value,
                         object.content_type)
    # obj = set_secondary_indexes(obj, options)
    case :riakc_pb_socket.put(pid, obj) do
      { :ok, new_obj } ->
        { :reply, :riakc_obj.key(new_obj) |> object.key, pid }
      :ok -> { :reply, object, pid }
    end
  end

  def handle_call({:get, bucket, key}, _from, pid) do
    res = case :riakc_pb_socket.get(pid, bucket, key) do
      {:ok, obj} ->
        record_from_obj(obj)
      { :error, :notfound } ->  { :error, :notfound }
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

  defp record_from_obj(obj) do
    Rex.Object.new(
      bucket: :riakc_obj.bucket(obj),
      key: :riakc_obj.key(obj),
      value: :riakc_obj.get_value(obj),
      content_type: :riakc_obj.get_content_type(obj)
    )
  end

end
