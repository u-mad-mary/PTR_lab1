defmodule Sentiment do
  use GenServer

  def start_link do
    #IO.puts "=== Starting sentiment ==="
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_state) do

    sentiment = HTTPoison.get!("localhost:4000/emotion_values")
    |> Map.get(:body)

    state = parse_sentiment(sentiment)
    {:ok, state}
  end

  def calculate_sentiment(pid, twt, hash, aggregator) do
    GenServer.call(pid, {twt, hash, aggregator})
  end

  def handle_call({twt, hash, aggregator}, _from, state) do
    words = String.downcase(twt) |> String.trim() |> String.split(~r/\s+/)
    mean_score = Enum.reduce(words, 0, fn word, acc ->
      case Map.get(state, word) do
        nil -> acc
        score -> acc + score
      end
    end) / Enum.count(words)

    Aggregator.add_sentiment(aggregator, hash, mean_score)

    {:reply, mean_score, state}
  end

  defp parse_sentiment(text) do
    text
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      words = String.split(line, ~r/\s+/, trim: true)
      value = String.to_integer(List.last(words))
      key = Enum.join(List.delete_at(words, -1), " ")
      Map.put(acc, key, value)
    end)
  end
end
