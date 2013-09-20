defmodule Rex.Resource do

  defmacro __using__(_) do

    quote do

      def ping do
        Rex.Server.ping
      end

      def bucket do
        atom_to_binary(__MODULE__) |> String.split(".") |> List.last
      end

      defoverridable [bucket: 0]

    end

  end

end
