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

  def handle_cast({:set_batcher, batcher}, {items, _}) do
    {:noreply, {items, batcher}}
  end

  def handle_cast({:add, action, hash, value}, {items, batcher}) do
    item = Map.get(items, hash, %{})
    item = Map.put(item, action, value)

    if Map.keys(item) |> Enum.sort() == [:text, :sentiment, :engagement] |> Enum.sort() do
      twt = format_message(hash, item)
      Batcher.add(batcher, twt)
      {:noreply, {Map.delete(items, hash), batcher}}
    else
      {:noreply, {Map.put(items, hash, item), batcher}}
    end
  end

  defp add(pid, hash, action, value) do
    GenServer.cast(pid, {:add, action, hash, value})
  end

  defp format_message(_hash, item) do
    "\n============================== Tweet ==============================\n Text: #{Map.get(item, :text, "")}\n Sentiment: #{Map.get(item, :sentiment, 0)}\n Engagement Rate: #{Map.get(item, :engagement, 0)}"
  end
end
