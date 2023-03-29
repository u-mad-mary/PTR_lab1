defmodule MainSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [
      %{
        id: :printer_supervisor,
        start: {PrinterSupervisor, :start_link, []}
      },
      %{
        id: :load_balancer,
        start: {LoadBalancer, :start_link, []}
      },
      %{
        id: :statistics,
        start: {Statistics, :start_link, []}
      },
      %{
        id: :cache,
        start: {Cache, :start_link, []}
      },
      %{
        id: :aggregator,
        start: {Aggregator, :start_link, []}
      },
      %{
        id: :batcher,
        start: {Batcher, :start_link, []}
      }
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

  def get_load_balancer(pid) do
    get_worker_pid(pid, :load_balancer)
  end

  def get_statistics(pid) do
    get_worker_pid(pid, :statistics)
  end

  def get_cache(pid) do
    get_worker_pid(pid, :cache)
  end

  def get_aggregator(pid) do
    get_worker_pid(pid, :aggregator)
  end

  def get_batcher(pid) do
    get_worker_pid(pid, :batcher)
  end

  def get_worker_pid(pid, id) do
    case Supervisor.which_children(pid)
    |> Enum.find(fn {i, _, _, _} -> i == id end) do
      {_, pid, _, _} -> pid
      nil -> nil
    end
  end
end
