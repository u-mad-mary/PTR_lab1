defmodule LoadBalancer do
  use GenServer

  @nr_workers 3
  @nr_requests 100
  @time_unit 5000

  def start_link do
    #IO.puts "=== Load balancer is started ==="
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_state) do
    scheduler()

    Enum.each(1..@nr_workers, fn i ->
      PrinterSupervisor.new_worker(i)
    end)

    {:ok, Enum.reduce(1..@nr_workers, %{}, fn (i, acc) -> Map.put(acc, i, 0) end)}
  end

  def get_least_conn_worker do
    GenServer.call(__MODULE__, :get_least_conn_worker)
  end

  def get_second_least_conn_worker do
    GenServer.call(__MODULE__, :get_second_least_conn_worker)
  end

  def handle_call(:get_least_conn_worker, _from, state) do
    id = state |> Enum.min_by(fn {_, v} -> v end) |> elem(0)
    total_workers = Enum.count(state)
    total_requests = Enum.reduce(state, 0, fn {_, v}, acc -> acc + v end)
    average_req = total_requests / total_workers

    if(average_req > @nr_requests) do
      #IO.puts(IO.ANSI.format([:cyan, "\nWorkers map #{inspect(state)}:"]))

      new_id = Enum.count(state) + 1

      case PrinterSupervisor.new_worker(new_id) do
        :ok -> {:reply, new_id, Map.update(state, new_id, 1, &(&1 + 1))}
        {:error, :running} -> {:reply, new_id, Map.update(state, new_id, 1, &(&1 + 1))}
        {:error, _} -> {:reply, id, Map.update(state, id, 1, &(&1 + 1))}
      end

    else
        {:reply, id, Map.update(state, id, 1, &(&1 + 1))}
    end
  end

  def handle_call(:get_second_least_conn_worker, _from, state) do
    id = state
    |> Enum.sort_by(fn {_, v} -> v end)
    |> Enum.at(1)
    |> elem(0)
    {:reply, id,  Map.update(state, id, 1, &(&1 + 1))}
  end

  def release_worker(id) do
    GenServer.cast(__MODULE__, {:release, id})
  end

  def reset_worker(id) do
    GenServer.cast(__MODULE__, {:reset, id})
  end

  defp scheduler do
    Process.send_after(self(), :work, @time_unit)
  end

  def handle_info(:work, state) do
    scheduler()

    total_workers = Enum.count(state)
    total_requests = Enum.reduce(state, 0, fn {_, v}, acc -> acc + v end)
    average_req = total_requests / (total_workers-1)

    if(average_req < @nr_requests && total_workers > @nr_workers) do
      #IO.puts(IO.ANSI.format([:light_cyan, "\n Workers map 2 #{inspect(state)}:"]))
      last_worker_requests = Map.get(state, total_workers, 0)
      PrinterSupervisor.remove_worker(total_workers)
      state = Map.delete(state, total_workers)
      state = Map.update(state, 1, last_worker_requests, &(&1 + last_worker_requests))
      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  def handle_cast({:release, id}, state) do
    case Map.get(state, id) do
      nil -> {:noreply, state}
      _ -> {:noreply, Map.update(state, id, 0, &(&1 - 1))}
    end
  end

  def handle_cast({:reset, id}, state) do
    case Map.get(state, id) do
      nil -> {:noreply, state}
      _ -> {:noreply, Map.update(state, id, 0, fn _ -> 0 end)}
    end
  end
end
