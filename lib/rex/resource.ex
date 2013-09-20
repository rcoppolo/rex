defmodule Rex.Resource do

  defmacro __using__(_) do

    quote do

      def put(key, value) do
        Rex.Server.put(bucket, key, value)
      end

      def get(key) do
        Rex.Server.get(bucket, key)
      end

      def delete(key) do
        Rex.Server.delete(bucket, key)
      end

      def bucket do
        atom_to_binary(__MODULE__) |> String.split(".") |> List.last
      end

      def ping do
        Rex.Server.ping
      end

      defoverridable [bucket: 0]

    end

  end

end
