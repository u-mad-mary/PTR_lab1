defmodule Reader do
  use GenServer

  def start_link(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def init(url) do
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
  end

  defp stream_processing("event: \"message\"\n\ndata: " <> message) do
    {success, data} = Jason.decode(String.trim(message))

    if success == :ok do
      tweet = data["message"]["tweet"]
      text = tweet["text"]
      hashtags = tweet["entities"]["hashtags"]
      PrinterSupervisor.print(text)
      Enum.each(hashtags, fn hashtag -> Statistics.hashtag_stats(hashtag["text"]) end)
    end
  end

  defp stream_processing(_other_data) do
    IO.puts(IO.ANSI.format([:red, "THE END"]))
    PrinterSupervisor.print(:kill)
  end
end
