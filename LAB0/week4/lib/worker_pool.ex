defmodule Worker do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, [id], name: {:global, :"worker_#{id}"})
  end

  def init([id]) do
    IO.puts("Worker #{inspect(id)} started.")
    {:ok, id}
  end

  def handle_info(:kill, id) do
    IO.puts("Worker #{inspect(id)} is killed.")
    {:stop, :killed, id}
  end

  def handle_info(message, id) do
    IO.puts("Worker #{inspect(id)} says: #{inspect(message)}.")
    {:noreply, id}
  end
end

defmodule WorkerSupervisor do
  use Supervisor

  def start_link(nr_workers) do
    Supervisor.start_link(__MODULE__, nr_workers, name: __MODULE__)
  end

  def init(nr_workers) do
    children = for id <- 1..nr_workers do
      %{
        id: id,
        start: {Worker, :start_link, [id]}
      }
    end
    Supervisor.init(children, strategy: :one_for_one)
  end

  def get_worker(id) do
    {_, worker_pid, _, _} =
      List.keyfind(
        Supervisor.which_children(__MODULE__), id, 0, fn {worker_id, _, _, _}, id -> worker_id == id end)
    worker_pid
  end

end

# WorkerSupervisor.start_link(3)
# worker = WorkerSupervisor.get_worker(2)
# send(worker, "hello worker 2")
# send(worker, :kill)
