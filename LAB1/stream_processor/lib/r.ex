defmodule Reader do
  use GenServer
  require Logger

  @url"http://localhost:4000/tweets/1"
  def start_link(url \\ @url) do
    GenServer.start_link(__MODULE__, url)
  end

  def init(url \\ @url) do
    IO.puts "=== Stream reader #{inspect(self())} is started ==="
    HTTPoison.get!(url, [], [recv_timeout: :infinity, stream_to: self()])
    {:ok, nil}
  end

  def handle_info(%HTTPoison.AsyncChunk{chunk: chunk}, _state) do
    stream_processing(chunk)
    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncStatus{} = status, _state) do
    IO.puts "Connection status: #{inspect(status)}"
    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncHeaders{} = headers, _state) do
    IO.puts "Connection headers: #{inspect(headers)}"
    {:noreply, nil}
  end

  def handle_info(%HTTPoison.AsyncEnd{} = connection_end, _state) do
    IO.puts "Connection end: #{inspect(connection_end)}"
    {:noreply, nil}
  end

  defp stream_processing("event: \"message\"\n\ndata: {\"message\": panic}\n\n") do
    PrinterSupervisor.print(:kill)
    IO.puts(IO.ANSI.format([:red, "Panic message"]))
  end

  defp stream_processing("event: \"message\"\n\ndata: " <> message) do
    {success, data} = Jason.decode(String.trim(message))

    if success == :ok do
      tweet = data["message"]["tweet"]
      text = tweet["text"]
      hashtags = tweet["entities"]["hashtags"]
      PrinterSupervisor.print(text)
      Enum.each(hashtags, fn hashtag -> Analyzer.analyze_hashtag(hashtag["text"]) end)
    end
  end

  defp stream_processing(_other_data) do
    IO.puts(IO.ANSI.format([:red, "OTHER"]))
    PrinterSupervisor.print(:kill)
  end
end
