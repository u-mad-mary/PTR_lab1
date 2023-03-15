defmodule Statistics do
  use GenServer

  @time 5

  def start_link do
    IO.puts "=== Stastistician is started ==="
    GenServer.start_link(__MODULE__, {System.system_time(:second), %{}}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def hashtag_stats(hashtag) do
    GenServer.cast(__MODULE__, hashtag)
  end

  def handle_cast(hashtag, state) do
    hashtags = state |> elem(1)
    hashtags = Map.update(hashtags, hashtag, 1, &(&1 + 1))

    start_time = state |> elem(0)
    current_time = System.system_time(:second)
    elapsed = current_time - start_time

    if elapsed > @time do
      hashtags = hashtags |> Enum.sort_by(&elem(&1, 1), &>=/2) |> Enum.take(5)

      IO.puts(IO.ANSI.format([:blue, "\nTop 5 hashtags in the last #{@time} seconds:"]))

      hashtags |> Enum.each(fn {hashtag, count} -> IO.puts(IO.ANSI.format([:blue, "#{hashtag}: #{count}"])) end)
      {:noreply, {System.system_time(:second), %{}}}
    else
      {:noreply, {start_time, hashtags}}
    end
  end
end
