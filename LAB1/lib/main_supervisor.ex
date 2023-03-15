defmodule MainSupervisor do
  use Supervisor

  @nr_of_workers 3

  def start_link(nr \\ @nr_of_workers) do
    IO.puts(IO.ANSI.format([:green, "==== Main Supervisor has started ==="]))
    Supervisor.start_link(__MODULE__, nr, name: __MODULE__)
  end

  def init(nr) do
    children = [
      %{
        id: :load_balancer,
        start: {LoadBalancer, :start_link, []}
      },
      %{
        id: :statistics,
        start: {Statistics, :start_link, []}
      },
      %{
        id: :printer_supervisor,
        start: {PrinterSupervisor, :start_link, [nr]}
      },
      %{
        id: :reader_supervisor,
        start: {ReaderSupervisor, :start_link, []}
      }
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
