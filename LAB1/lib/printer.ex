defmodule Printer do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  def init(id) do
    {:ok, redactor} = Redactor.start_link()
    {:ok, engagement} = Engagement.start_link()
    {:ok, sentiment} = Sentiment.start_link()
    state = {id, redactor, engagement, sentiment}
    {:ok, state}
  end

  def print(pid, load_balancer_pid, cache_pid, aggregator_pid, twt) do
    GenServer.cast(pid, {twt, load_balancer_pid, cache_pid, aggregator_pid})
  end

  def handle_cast({{:kill, _stats}, load_balancer_pid, _cache_pid, _aggregator_pid}, state) do
    id = elem(state, 0)
    IO.puts(IO.ANSI.format([:red,"=== Kill printer #{state} ==="]))
    LoadBalancer.reset_worker(load_balancer_pid, id)
    {:stop, :normal, state}
  end

  def handle_cast({{text, stats}, load_balancer_pid, cache_pid, aggregator_pid}, state) do
    {id, redactor, engagement, sentiment} = state

    hash = :crypto.hash(:md5, text) |> Base.encode16()
    case Cache.get(cache_pid, hash) do
      true ->
        LoadBalancer.release_worker(load_balancer_pid, id)
        {:noreply, state}
      false ->
        Cache.put(cache_pid, hash)

        Sentiment.calculate_sentiment(sentiment, text, hash, aggregator_pid)
        Engagement.calculate_engagement(engagement, stats, hash, aggregator_pid)
        Redactor.filter_bad_words(redactor, text, hash, aggregator_pid)

        LoadBalancer.release_worker(load_balancer_pid, id)
        {:noreply, state}
    end
  end
end
