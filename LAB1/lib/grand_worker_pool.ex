defmodule LeGrandWorkerPool do
  use Supervisor

  @nr_of_workers 3

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = Enum.map(1..@nr_of_workers, fn id ->
      %{
        id: id,
        start: {WorkerPool, :start_link, [id]}
      }
    end)

    Supervisor.init(children, strategy: :one_for_one)
  end

  def print(id, twt) do
    pid = get_worker_pid(__MODULE__, id)
    WorkerPool.print(pid, twt)
  end

  def get_worker_pid(super_pid, id) do
    case Supervisor.which_children(super_pid)
    |> Enum.find(fn {i, _, _, _} -> i == id end) do
      {_, pid, _, _} -> pid
      nil -> nil
    end
  end

end
