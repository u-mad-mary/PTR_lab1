defmodule Redactor do
  use GenServer

  def start_link do
    #IO.puts "=== Starting redactor ==="
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_state) do
    {:ok, %{}}
  end

  def filter_bad_words(pid, twt, hash, aggregator) do
    GenServer.call(pid, {twt, hash, aggregator})
  end

  def handle_call({twt, hash, aggregator}, _from, state) do
    twt = URI.encode(twt)
    clean_msg = HTTPoison.get!("https://www.purgomalum.com/service/plain?text=#{twt}")
    |> Map.get(:body)

    Aggregator.add_text(aggregator, hash, clean_msg)

    {:reply, clean_msg, state}
  end
end
