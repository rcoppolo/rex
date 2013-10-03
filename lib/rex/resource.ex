defmodule Rex.Resource do

  defmacro __using__(_) do

    quote do

      def ping do
        Rex.Server.ping()
      end

      def put(key, value, options // []) do
        Rex.Server.put(bucket, key, value, options)
      end

      def get(key) do
        Rex.Server.get(bucket, key)
      end

      def delete(key) do
        Rex.Server.delete(bucket, key)
      end

      def search(query) do
        Rex.Server.search(bucket, query)
      end

      def get_index(index, query) do
        Rex.Server.get_index(bucket, index, query)
      end

      def bucket do
        atom_to_binary(__MODULE__)
      end

      defoverridable [bucket: 0]

    end

  end

end
