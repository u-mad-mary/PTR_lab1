defmodule Statistics do
  use GenServer

  @time_unit 5000

  def start_link do
    #IO.puts "=== Stastistician is started ==="
    GenServer.start_link(__MODULE__,  %{}, name: __MODULE__)
  end

  def init(state) do
    scheduler()
    {:ok, state}
  end

  def hashtag_stats(hashtag) do
    GenServer.cast(__MODULE__, hashtag)
  end

  def handle_info(:work, state) do
    hashtags = state |> Enum.sort_by(&elem(&1, 1), &>=/2) |> Enum.take(5)
    case hashtags do
      [] -> {:noreply, %{}}
      _ ->
        IO.puts(IO.ANSI.format([:blue, "\nTop 5 hashtags in the last #{@time_unit} seconds:"]))
        hashtags |> Enum.each(fn {hashtag, count} -> IO.puts(IO.ANSI.format([:blue, "#{hashtag}: #{count}"])) end)
        scheduler()
        {:noreply, %{}}
    end
  end

  def handle_cast(hashtag, state) do
    state = Map.update(state, hashtag, 1, &(&1 + 1))
    {:noreply, state}
  end

  defp scheduler do
    Process.send_after(self(), :work, @time_unit)
  end

end
