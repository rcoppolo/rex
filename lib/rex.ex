defmodule Rex do
  use Application.Behaviour

  use Rex.Server

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, _args) do
    Rex.Supervisor.start_link
  end
end
