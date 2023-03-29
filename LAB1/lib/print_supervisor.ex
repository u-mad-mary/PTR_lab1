defmodule PrinterSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_nr) do
    Supervisor.init([], strategy: :one_for_one)
  end

  def new_worker(super_pid, id) do
    case get_worker_pid(super_pid, id) do
      nil -> start_worker(super_pid, id)
      _ -> restart_worker(super_pid, id)
    end
  end

  defp start_worker(super_pid, id) do
    #IO.puts("=== Starting new printer #{id} ===")
    case Supervisor.start_child(super_pid, %{
      id: id,
      start: {Printer, :start_link, [id]}
    }) do
      {:ok, _} -> :ok
      {:error, reason} ->
        IO.puts("\n Error starting worker #{id}: #{inspect reason}")
        {:error, reason}
    end
  end

  defp restart_worker(super_pid, id) do
    IO.puts("\n Restarting worker #{id}...")
    case Supervisor.restart_child(super_pid, id) do
      {:ok, _} -> :ok
      {:error, reason} ->
        IO.puts("\n Error restarting worker #{id}: #{inspect reason}")
        {:error, reason}
    end

    IO.puts("\nRestarting worker #{id}...")
    case get_worker_pid(super_pid, id) do
      nil ->
        IO.puts(IO.ANSI.format([:magenta,"\nWorker #{super_pid} is not running."]))
        {:error, "Worker #{id} is not running."}
      pid ->
        Process.exit(pid, :shutdown) # Stop the existing worker process
        case Supervisor.start_child(__MODULE__, %{
          id: id,
          start: {Printer, :start_link, [super_pid]}
        }) do
          {:ok, new_super_pid} ->
            {:ok, new_super_pid}
          {:error, reason} ->
            IO.puts(IO.ANSI.format([:red, "\nError starting worker #{id}: #{inspect(reason)}"]))
            {:error, reason}
        end
    end
  end

  def remove_worker(super_pid, id) do
    IO.puts("\n Terminating worker #{id}...")
    case get_worker_pid(super_pid, id) do
      nil -> :ok
      _ -> terminate_worker(super_pid, id)
    end
  end

  defp terminate_worker(super_pid, id) do
    case Supervisor.terminate_child(super_pid, id) do
      :ok -> :ok
      {:error, reason} ->
        IO.puts("\n Error terminating worker #{id}: #{inspect(reason)}")
        {:error, reason}
    end
  end

  def print(super_pid, load_balancer_pid, cache_pid, aggregator_pid, id, twt) do
    pid = get_worker_pid(super_pid, id)
    Printer.print(pid, load_balancer_pid, cache_pid, aggregator_pid, twt)
  end

  def get_worker_pid(super_pid, id) do
    case Supervisor.which_children(super_pid)
    |> Enum.find(fn {i, _, _, _} -> i == id end) do
      {_, pid, _, _} -> pid
      nil -> nil
    end
  end

  def count(super_pid) do
    Supervisor.count_children(super_pid)
  end
end
