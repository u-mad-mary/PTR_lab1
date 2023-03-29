defmodule Statistics do
  use GenServer

  @time_unit 5000

  def start_link do
     #IO.puts "=== Stastistician is started ==="
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    scheduler()
    {:ok, state}
  end
  def hashtag_stats(pid, hashtag) do
    GenServer.cast(pid, hashtag)
  end

  def handle_info(:work, state) do
    hashtags = state |> Enum.sort_by(&elem(&1, 1), &>=/2) |> Enum.take(5)
    case hashtags do
      [] -> {:noreply, %{}}
      _ ->

        top_hashtags =
          Enum.reduce(hashtags, "", fn {k, v}, acc ->
            acc <> "#{k}: #{v}\n"
          end)

        IO.puts(IO.ANSI.format([:white, "\nTop 5 hashtags in the last 5 seconds:"]))
        result_string =
          top_hashtags
          |> String.split("\n")
          |> Enum.join("\n")

        IO.puts(IO.ANSI.format([:white, result_string]))

        scheduler()
        {:noreply, %{}}
    end
  end

  def handle_cast(hashtag, state) do
    state = Map.update(state, hashtag, 1, &(&1 + 1))
    {:noreply,state}
  end

  defp scheduler do
    Process.send_after(self(), :work, @time_unit)
  end
end
