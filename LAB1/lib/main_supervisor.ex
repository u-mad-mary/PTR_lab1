defmodule MainSupervisor do
  use Supervisor

  def start_link do
    IO.puts(IO.ANSI.format([:green, "==== Main Supervisor has started ==="]))
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
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
        id: :reader_supervisor,
        start: {ReaderSupervisor, :start_link, []}
      }
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
