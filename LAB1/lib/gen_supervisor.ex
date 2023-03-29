defmodule GenSupervisor do
  use Supervisor

  def start_link do
    #IO.puts "=== Starting general supervisor ==="
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      %{
        id: :user_cache,
        start: {UserCache, :start_link, []}
      },
      %{
        id: :grand_worker_pool,
        start: {LeGrandWorkerPool, :start_link, []}
      },
      %{
        id: :reader_supervisor,
        start: {ReaderSupervisor, :start_link, []}
      },

    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
