defmodule Batcher do
  use GenServer

  @size 10
  @time_unit 5

  def start_link do
    GenServer.start_link(__MODULE__, {[], System.system_time(:second)})
  end

  def init(state) do
    scheduler()
    {:ok, state}
  end

  def request(pid, item) do
    GenServer.cast(pid, {:request, item})
  end

  def handle_cast({:request, item}, state) do
    {items, timestamp} = state
    items = [item | items]
    if Enum.count(items) == @size do
      Enum.each(items, fn item -> IO.puts(item) end)
      {:noreply, {[], System.system_time(:second)}}
    else
      {:noreply, {items, timestamp}}
    end
  end

  defp scheduler do
    Process.send_after(self(), :work, @time_unit * 1000)
  end

  def handle_info(:work, state) do
    {items, timestamp} = state
    scheduler()

    start_time = timestamp
    current_time = System.system_time(:second)
    elapsed = current_time - start_time

    if elapsed < @time_unit || Enum.count(items) == 0 do
      {:noreply, {items, timestamp}}
    else
      Enum.each(items, fn item -> IO.puts(item) end)
      {:noreply, {[], System.system_time(:second)}}
    end
  end
end
