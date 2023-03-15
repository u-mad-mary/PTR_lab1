defmodule LoadBalancer do
  use GenServer

  @nr_of_workers 3

  def start_link(nr \\ @nr_of_workers) do
    IO.puts "=== Load balancer is started ==="
    state = Enum.reduce(1..nr, %{}, fn (i, acc) -> Map.put(acc, i, 0) end)
    IO.puts(IO.ANSI.format([:cyan, "Init state:  #{inspect(state)}"]))
    GenServer.start_link(__MODULE__, {state, 1}, name: __MODULE__)
  end

  def init({state, counter}) do
    {:ok, {state, counter}}
  end

  def get_least_conn_worker do
    GenServer.call(__MODULE__, :get_least_conn_worker)
  end

  def handle_call(:get_least_conn_worker, _from, {state, counter}) do
    least_busy_worker_count = counter
    state = Map.update(state, least_busy_worker_count, 1, &(&1 + 1))
    counter =
      if counter == map_size(state) do
        1
      else
        counter + 1
      end
    {:reply, least_busy_worker_count, {state, counter}}
  end

  def release_worker(id) do
    GenServer.cast(__MODULE__, {:release, id})
  end

  def handle_cast({:release, id}, {state, counter}) do
    state = Map.update(state, id, 0, &(&1 - 1))
    {:noreply, {state, counter}}
  end
end
