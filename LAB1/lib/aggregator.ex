defmodule Aggregator do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, {%{}, 0})
  end

  def init(state) do
    {:ok, state}
  end

  def add_text(pid, hash, text) do
    add(pid, hash, :text, text)
  end

  def add_sentiment(pid, hash, sentiment) do
    add(pid, hash, :sentiment, sentiment)
  end

  def add_engagement(pid, hash, engagement) do
    add(pid, hash, :engagement, engagement)
  end

  def set_batcher(pid, batcher) do
    GenServer.cast(pid, {:set_batcher, batcher})
  end

  def handle_cast({:set_batcher, batcher}, {items, count}) do
    {:noreply, {items, count, batcher}}
  end

  def handle_cast({:add, action, hash, value}, {items, count, batcher} = state) do
    case Process.alive?(batcher) do
      true ->
        item = Map.get(items, hash, %{})
        item = Map.put(item, action, value)

        if Map.keys(item) |> Enum.sort() == [:text, :sentiment, :engagement] |> Enum.sort() do
          msg = format_message(count, hash, item)
          Batcher.request(batcher, msg)
          {:noreply, {Map.delete(items, hash), count + 1, batcher}}
        else
          {:noreply, {Map.put(items, hash, item), count, batcher}}
        end
      false ->
        IO.puts("Batcher process is not ready to recieve data.\n")
        {:noreply, state}
    end
  end

  defp add(pid, hash, action, value) do
    GenServer.cast(pid, {:add, action, hash, value})
  end

  defp format_message(count, _hash, item) do
    "\n ============================== Tweet #{count} ============================== \n Text: #{Map.get(item, :text, "")} \n\t- Sentiment: #{Map.get(item, :sentiment, 0)}\n\t- Engagement: #{Map.get(item, :engagement, 0)}\n\t"
  end
end
