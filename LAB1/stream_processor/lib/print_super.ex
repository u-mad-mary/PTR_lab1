defmodule PrinterSupervisor do
  use Supervisor

  def start_link(nr) do
    Supervisor.start_link(__MODULE__, nr, name: __MODULE__)
  end

  def init(nr) do
    children = for id <- 1..nr do
      %{
        id: id,
        start: {Printer, :start_link, [id]},
        restart: :permanent
      }
    end

    Supervisor.init(children, strategy: :one_for_one)
  end

  def print(msg) do
    id = LoadBalancer.get_least_busy_worker()
    pid = get_worker(id)
    Printer.print(pid, msg)
  end

  def get_worker(id) do
    {_, worker_pid, _, _} =
      List.keyfind(
        Supervisor.which_children(__MODULE__), id, 0, fn {worker_id, _, _, _}, id -> worker_id == id end)
    worker_pid
  end

  def restart_worker(worker_id) do
    worker_pid = get_worker(worker_id)
    Supervisor.restart_child(__MODULE__, worker_pid)
  end

  def count() do
    Supervisor.count_children(__MODULE__)
  end
end
