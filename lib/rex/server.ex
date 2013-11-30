defmodule Rex.Server do

  use GenServer.Behaviour

  def start_link() do
    :gen_server.start_link({:local, :rex_server}, __MODULE__, [], [])
  end

  def init([]) do
    {:ok, config} = :application.get_env(:rex, :riak)
    poolargs = [
      name: {:local, :riak},
      worker_module: Rex.Worker,
      size: config[:size],
      max_overflow: config[:max_overflow]
    ]
    workerargs = [
      port: config[:port],
      host: config[:host]
    ]
    :poolboy.start_link(poolargs, workerargs)
    {:ok, []}
  end

  def handle_call(query, _from, _pid) do
     res = :poolboy.transaction(:riak, fn(worker) ->
       :gen_server.call(worker, query)
     end)
     { :reply, res, [] }
  end

  # interface
  defmacro __using__(_) do

    quote do

      def ping() do
        :gen_server.call(:rex_server, :ping)
      end

      def put(bucket, key, value, options // []) do
        :gen_server.call(:rex_server, {:put, bucket, key, value, options})
      end

      def get(bucket, key) do
        :gen_server.call(:rex_server, {:get, bucket, key})
      end

      def get_index(bucket, index, query) do
        :gen_server.call(:rex_server, {:get_index, bucket, index, query})
      end

      def delete(bucket, key) do
        :gen_server.call(:rex_server, {:delete, bucket, key})
      end

      def search(bucket, query) do
        :gen_server.call(:rex_server, {:search, bucket, query})
      end

    end

  end

end
