defmodule Monitor do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {:monitoring, pid} ->
        Process.monitor(pid)
        loop()

      {:DOWN, _ref, :process, _obj, reason} ->
        IO.puts("The monitored actor stopped, due to #{reason}.")
    end
  end
end

# monitoring_pid = Monitor.start
# monitored_pid = Print.start
# send(monitoring_pid, {:monitoring, monitored_pid})
# Process.exit(monitored_pid, :kill)
