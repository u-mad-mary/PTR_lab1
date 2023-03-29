defmodule Reader do
  use GenServer

  @nr_of_workers 3

  def start_link(url) do
    #IO.puts "=== Stream reader #{inspect(self())} is started ==="
    GenServer.start_link(__MODULE__, url)
  end

  def init(url) do
    HTTPoison.get!(url, [], [recv_timeout: :infinity, stream_to: self()])
    {:ok, nil}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, _state) do
    stream_processing(chunk)
    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncStatus{} = status, _state) do
    IO.puts "\n Connection status: #{inspect status}"
    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncHeaders{} = headers, _state) do
    IO.puts "\n Connection headers: #{inspect headers}"
    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncEnd{} = connection_end, _state) do
    IO.puts "\n Connection end: #{inspect connection_end}"
    {:noreply, nil}
  end

  defp stream_processing("event: \"message\"\n\ndata: " <> message) do
    {success, data} = Jason.decode(String.trim(message))

    if success == :ok do
      send_to_worker_pool(data["message"]["tweet"])
    end
  end

  defp stream_processing(_other_data) do
    twt = {{:kill, {}}, []}

    id = Enum.random(1..@nr_of_workers)
    LeGrandWorkerPool.print(id, twt)
  end

  defp send_to_worker_pool(tweet) do
    data = tweet["text"]
    favorites = tweet["favorite_count"]
    retweets = tweet["retweet_count"]
    followers = tweet["user"]["followers_count"]
    name = tweet["user"]["name"]
    hashtags = Enum.map(tweet["entities"]["hashtags"], fn hashtag -> hashtag["text"] end)

    twt = {{data, {favorites, retweets, followers, name}}, hashtags}

    id = Enum.random(1..@nr_of_workers)
    LeGrandWorkerPool.print(id, twt)

    if Map.get(tweet, "retweeted_status", nil) != nil do
      send_to_worker_pool(tweet["retweeted_status"])
    end
  end
end
