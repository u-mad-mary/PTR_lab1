defmodule WorkerPool do
  use GenServer

  def start_link(id) do
    # IO.puts "=== Starting worker #{id}==="
    GenServer.start_link(__MODULE__, id)
  end

  def init(id) do
    {:ok, bonus} = MainSupervisor.start_link()
    {:ok, printer} = PrinterSupervisor.start_link()
    load_balancer = MainSupervisor.get_load_balancer(bonus)
    statistics = MainSupervisor.get_statistics(bonus)
    cache = MainSupervisor.get_cache(bonus)
    batcher = MainSupervisor.get_batcher(bonus)
    aggregator = MainSupervisor.get_aggregator(bonus)

    Aggregator.set_batcher(aggregator, batcher)
    LoadBalancer.set_printer(load_balancer, printer)
    state = {id, {printer, load_balancer, statistics, cache, batcher, aggregator}}
    {:ok, state}
  end

  def print(pid, twt) do
    GenServer.cast(pid, twt)
  end

  def handle_cast(twt, state) do
    {_, {printer, load_balancer, statistics, cache, _batcher, aggregator}} = state
    {twt, hashtags} = twt

    id = LoadBalancer.get_least_conn_worker(load_balancer)
    PrinterSupervisor.print(printer, load_balancer, cache, aggregator, id, twt)
    Enum.each(hashtags, fn hashtag ->
      Statistics.hashtag_stats(statistics, hashtag)
    end)

    {:noreply, state}
  end
end
