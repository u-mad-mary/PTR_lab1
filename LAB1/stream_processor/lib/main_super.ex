defmodule MainSuper do
  use Supervisor

  @nr_of_workers 3

  def start_link(nr \\ @nr_of_workers) do
    IO.puts "=== Main Superviser is started ==="
    {:ok, pid} = Supervisor.start_link(__MODULE__, nr, name: __MODULE__)
    pid
  end

  def init(nr) do
    children = [
      %{
        id: :load_balancer,
        start: {LoadBalancer, :start_link, []}
      },
      %{
        id: :analyzer,
        start: {Analyzer, :start_link, []}
      },
      %{
        id: :printer_supervisor,
        start: {PrinterSupervisor, :start_link, [nr]}
      }
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

  def count() do
    Supervisor.count_children(__MODULE__)
  end
end
