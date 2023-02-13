defmodule Scheduler do
  use GenServer

  def start do
    GenServer.start(__MODULE__, :start_worker, name: :worker)
  end

  def init(args) do
    {:ok, args}
  end

  def handle_info(task, state) do
    result = perform_task(task)

    if result == :success do
      IO.puts("Task successful: Miau")
      {:noreply, state}
    else
      IO.puts("Task failed")
      restart_worker()
      {:noreply, state}
    end
  end

  defp perform_task(_task) do
    if Enum.random(0..1) == 1 do
      :success
    else
      :fail
    end
  end

  def restart_worker do
    Process.sleep(3)
    GenServer.cast(__MODULE__, :restart)
    start_worker()
    IO.puts("Restart the worker...")
  end

  def start_worker do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {task} ->
        perform_task(task)
        loop()
    end
  end
end

# Scheduler.start
# send(Worker, "hi")
