defmodule LoadBalancer do
  use GenServer

  @time_unit 5000
  @nr_of_workers 3
  @nr_of_requests 100

  def start_link do
    #IO.puts "=== Load balancer is started ==="
    GenServer.start_link(__MODULE__, {})
  end

  def init(state) do
    scheduler()
    {:ok, state}
  end

  def set_printer(pid, printer_pid) do
    GenServer.cast(pid, {:set_printer, printer_pid})
  end

  def get_least_conn_worker(pid) do
    GenServer.call(pid, :get_least_conn_worker)
  end
  def get_second_least_conn_worker do
    GenServer.call(__MODULE__, :get_second_least_conn_worker)
  end

  def handle_call(:get_least_conn_worker, _from, state) do
    {map, printer_pid} = state
    id = map |> Enum.min_by(fn {_, v} -> v end) |> elem(0)
    {:reply, id, {Map.update(map, id, 1, &(&1 + 1)), printer_pid}}
  end

  def handle_call(:get_second_least_conn_worker, _from, state) do
    {map, printer_pid} = state
    {min_id, min_value} = map |> Enum.min_by(fn {_, v} -> v end)

    second_min_value = map
      |> Enum.reject(fn {_, v} -> v == min_value end)
      |> Enum.min_by(fn {_, v} -> v end)
      |> elem(1)

    id =
      case second_min_value do
        nil -> min_id
        _ -> second_min_value
      end

    {:reply, id, {map, printer_pid}}
  end

  def release_worker(pid, id) do
    GenServer.cast(pid, {:release, id})
  end

  def reset_worker(pid, id) do
    GenServer.cast(pid, {:reset, id})
  end

  defp scheduler do
    Process.send_after(self(), :work, @time_unit)
  end

  def handle_info(:work, state) do
    {map, printer_pid} = state
    scheduler()

    #IO.puts(IO.ANSI.format([:cyan, "\nWorkers map #{inspect(map)}:"]))

    nr_of_workers = Enum.count(map)
    nr_of_requests = Enum.reduce(map, 0, fn {_, v}, acc -> acc + v end)
    avg_req = nr_of_requests / (nr_of_workers-1)

    if(avg_req < @nr_of_requests && nr_of_workers > @nr_of_workers) do

      PrinterSupervisor.remove_worker(printer_pid, nr_of_workers)
      {:noreply, {Map.delete(map, nr_of_workers), printer_pid}}

    else

      if (avg_req > @nr_of_requests) do

        new_id = Enum.count(map) + 1

        case PrinterSupervisor.new_worker(printer_pid, new_id) do
          :ok -> {:noreply, {Map.update(map, new_id, 0, fn _ -> 0 end), printer_pid}}
          {:error, :running} -> {:noreply, {Map.update(map, new_id, 0, fn _ -> 0 end), printer_pid}}
          {:error, _} -> {:noreply, {map, printer_pid}}
        end

      else
        {:noreply, {map, printer_pid}}
      end
    end
  end

  def handle_cast({:release, id}, state) do
    {map, printer_pid} = state
    case Map.get(map, id) do
      nil -> {:noreply, {map, printer_pid}}
      _ -> {:noreply, {Map.update(map, id, 0, &(&1 - 1)), printer_pid}}
    end
  end

  def handle_cast({:reset, id}, state) do
    {map, printer_pid} = state
    case Map.get(map, id) do
      nil -> {:noreply, {map, printer_pid}}
      _ -> {:noreply, {Map.update(map, id, 0, fn _ -> 0 end), printer_pid}}
    end
  end

  def handle_cast({:set_printer, printer_pid}, _state) do
    Enum.each(1..@nr_of_workers, fn i ->
      PrinterSupervisor.new_worker(printer_pid, i)
    end)
    {:noreply, {Enum.reduce(1..@nr_of_workers, %{}, fn (i, acc) -> Map.put(acc, i, 0) end), printer_pid}}
  end
end
