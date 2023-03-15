defmodule Printer do
  use GenServer

  @min_sleep_time 5
  @max_sleep_time 50

  def start_link(id) do
    IO.puts(IO.ANSI.format([:green, "=== Printer #{id} is started ==="]))
    GenServer.start_link(__MODULE__, id)
  end

  def init(id) do
    {:ok, id}
  end

  def print(worker, msg) do
    GenServer.cast(worker, msg)
  end

  def handle_cast(:kill, id) do
    IO.puts(IO.ANSI.format([:yellow,"=== Killing printer #{id}==="]))
    LoadBalancer.release_worker(id)
    {:stop, :normal, id}
  end

  def handle_cast(msg, id) do
    sleep_randomly()
    IO.puts("Printer#{inspect(id)} : #{inspect(msg)}")
    LoadBalancer.release_worker(id)
    {:noreply, id}
  end

  def sleep_randomly do
    sleep_time = :rand.uniform(@max_sleep_time - @min_sleep_time) + @min_sleep_time
    Process.sleep(sleep_time)
  end
end
