defmodule Engagement do

  def start_link do
    #IO.puts "=== Starting engagement ==="
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_state) do
    {:ok, %{}}
  end

  def calculate_engagement(pid, {favorites, retweets, followers, name}, hash, aggregator) do
    GenServer.call(pid, {{favorites, retweets, followers, name}, hash, aggregator})
  end

  def handle_call({{favorites, retweets, followers, name}, hash, aggregator}, _from, state) do
    if followers != 0 do
      engagement = (favorites + retweets) / followers
      UserCache.set(name, engagement)
      Aggregator.add_engagement(aggregator, hash, engagement)
      {:reply, engagement, state}
    else
      Aggregator.add_engagement(aggregator, hash, 0)
      {:reply, 0, state}
    end
  end

end
