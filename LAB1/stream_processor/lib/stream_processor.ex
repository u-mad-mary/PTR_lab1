defmodule StreamProcessor.Application do
  use Application

  def start(_type, _args) do
    children = [
      # Add MainSuper as a child process
      MainSuper
    ]

    # Start the supervisor with the updated list of children
    opts = [strategy: :one_for_one, name: StreamProcessor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
# Application.start(:stream_processor)
