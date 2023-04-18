defmodule TweetCache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ets.new(:tweet_cache, [:set, :public]), name: __MODULE__)
  end

  def init(ets_table) do
    {:ok, ets_table}
  end

  def set(tweets) do
    GenServer.cast(__MODULE__, {:set, tweets})
  end

  def handle_cast({:set, tweets}, ets_table) do
    Enum.each(tweets, fn {tweet, username} ->
      IO.puts("============================== #{username}'s Tweet ============================== #{tweet}")
      :ets.insert(ets_table, {tweet, username})
    end)
    {:noreply, ets_table}
  end

end
