defmodule Printer do
  use GenServer

  @max_time 50
  @min_time 5

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  def init(state) do
    {:ok, state}
  end

  def print(worker, twt) do
    GenServer.cast(worker, twt)
  end

  def handle_cast(:kill, state) do
    IO.puts(IO.ANSI.format([:red,"=== Kill printer #{state} ==="]))
    PrinterSupervisor.restart_worker(state)
    {:stop, :normal, state}
  end

  def handle_cast(twt, state) do
    :timer.sleep(:rand.uniform(@max_time) + @min_time)
    IO.puts("Printer#{inspect(state)} : #{inspect(twt)}")
    LoadBalancer.release_worker(state)
    IO.puts(IO.ANSI.format([:yellow, "Printer #{inspect(state)} is released"]))
    {:noreply, state}
  end
end
