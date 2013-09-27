defmodule Rex.Supervisor do

  use Supervisor.Behaviour

  def start_link() do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    tree = [ worker(Rex.Server, []) ]
    supervise(tree, strategy: :one_for_all)
  end

end
