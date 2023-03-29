# defmodule Profanity do
#   use GenServer

#   def start_link do
#     IO.puts "\n## Starting profanity..."
#     GenServer.start_link(__MODULE__, %{})
#   end

#   def init(_state) do
#     {:ok, %{}}
#   end

#   def filter_bad_words(pid, msg) do
#     GenServer.call(pid, msg)
#   end

#   def handle_call(twt, _from, state) do
#     encoded_twt = URI.encode(twt)
#     url = "https://www.purgomalum.com/service/plain?text=#{encoded_twt}"
#     response = HTTPoison.get!(url)
#     {:reply, response.body, state}
#   end
# end

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
