defmodule UserCache do
  use GenServer

  @time_unit 5000

  def start_link do
    GenServer.start_link(__MODULE__, :ets.new(:user_cache, [:set, :public]), name: __MODULE__)
  end

  def init(ets_table) do
    scheduler()
    {:ok, ets_table}
  end

  defp scheduler do
    Process.send_after(self(), :work, @time_unit)
  end

  def set(k, v) do
    GenServer.cast(__MODULE__, {:set, k, v})
  end

  def handle_cast({:set, key, value}, ets_table) do
    case :ets.lookup(ets_table, key) do
      [] -> :ets.insert(ets_table, {key, value})
      [{^key, old_value}] -> :ets.insert(ets_table, {key, old_value + value})
    end
    {:noreply, ets_table}
  end

  def handle_info(:work, ets_table) do
    scheduler()

    items = :ets.tab2list(ets_table)
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

    {:noreply, ets_table}
  end

end
