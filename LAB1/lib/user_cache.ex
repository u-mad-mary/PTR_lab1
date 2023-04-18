defmodule UserCache do
  use GenServer

  @time_unit 5000

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    scheduler()
    {:ok, state}
  end

  defp scheduler do
    Process.send_after(self(), :work, @time_unit)
  end

  def set(k, v) do
    GenServer.cast(__MODULE__, {:set, k, v})
  end

  def handle_cast({:set, k, v}, state) do
    new_state = Map.update(state, k, v, &(&1 + v))
    {:noreply, new_state}
  end

  def handle_info(:work, state) do
    scheduler()

    items = Map.to_list(state)
    sorted_items = Enum.sort_by(items, fn {_, v} -> v end, &>=/2)

    top_eng =
      Enum.reduce(Enum.take(sorted_items, 5), "", fn {k, v}, acc ->
        acc <> "#{k}: #{v}\n"
      end)

    IO.puts(IO.ANSI.format([:magenta, "\n Top 5 users by engagement:"]))

    result_string =
      top_eng
      |> String.split("\n")
      |> Enum.join("\n")

    IO.puts(IO.ANSI.format([:magenta, result_string]))

    {:noreply, state}
  end
end
