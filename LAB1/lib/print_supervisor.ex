defmodule PrinterSupervisor do
  use Supervisor

  def start_link do
    #IO.puts "=== Printer Supervisor is started ==="
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_nr) do
    Supervisor.init([], strategy: :one_for_one)
  end

  def new_worker(worker_id) do
    #IO.puts(IO.ANSI.format([:magenta, "All children: #{inspect(Supervisor.which_children(__MODULE__))}"]))
    case get_worker_pid(worker_id) do
      nil -> start_worker(worker_id)
      _ -> restart_worker(worker_id)
    end
  end

  defp start_worker(worker_id) do
    IO.puts(IO.ANSI.format([:green,"\n Starting new worker #{worker_id}..."]))
    case Supervisor.start_child(__MODULE__, %{
      id: worker_id,
      start: {Printer, :start_link, [worker_id]}
    }) do
      {:ok, _} -> :ok
      {:error, reason} ->
        IO.puts(IO.ANSI.format([:magenta, "\n Error starting worker #{worker_id}: #{inspect(reason)}"]))
        {:error, reason}
    end
  end

  def restart_worker(worker_id) do
    IO.puts("\nRestarting worker #{worker_id}...")
    case get_worker_pid(worker_id) do
      nil ->
        IO.puts(IO.ANSI.format([:magenta,"\nWorker #{worker_id} is not running."]))
        {:error, "Worker #{worker_id} is not running."}
      pid ->
        Process.exit(pid, :shutdown) # Stop the existing worker process
        case Supervisor.start_child(__MODULE__, %{
          id: worker_id,
          start: {Printer, :start_link, [worker_id]}
        }) do
          {:ok, new_pid} ->
            {:ok, new_pid}
          {:error, reason} ->
            IO.puts(IO.ANSI.format([:red, "\nError starting worker #{worker_id}: #{inspect(reason)}"]))
            {:error, reason}
        end
    end
  end

  def remove_worker(worker_id) do
    IO.puts("\nTerminating worker #{worker_id}...")
    case get_worker_pid(worker_id) do
      nil -> :ok
      pid -> terminate_worker(worker_id, pid)
    end
  end

  defp terminate_worker(worker_id, pid) do
    messages = get_worker_pid_messages(pid)

    case Supervisor.terminate_child(__MODULE__, worker_id) do
      :ok ->
        Enum.each(messages, fn twt -> print(twt, 1) end)
        :ok
      {:error, reason} ->
        IO.puts("\nError terminating worker #{worker_id}: #{inspect reason}")
        {:error, reason}
    end
  end

  def print_spec(twt) do
    worker_id = LoadBalancer.get_least_conn_worker()
    print(twt, worker_id)
    id2 = LoadBalancer.get_second_least_conn_worker()
    print(twt, id2)
    #IO.puts(IO.ANSI.format([:red, "\n LEAST_1 worker_id# #{inspect(worker_id)}, LEAST_2 worker_id# #{inspect(id2)}"]))
  end

  def print(twt) do
    worker_id = LoadBalancer.get_least_conn_worker()
    print(twt, worker_id)
  end

  def print(twt, worker_id) do
    pid = get_worker_pid(worker_id)
    Printer.print(pid, twt)
  end

  def get_worker_pid(worker_id) do
    case Supervisor.which_children(__MODULE__)
    |> Enum.find(fn {i, _, _, _} -> i == worker_id end) do
      {_, pid, _, _} -> pid
      nil -> nil
    end
  end

  defp get_worker_pid_messages(pid) do
    {:messages, messages} = Process.info(pid, :messages)
    Enum.map(messages, fn {_, twt} -> twt end)
  end
end
