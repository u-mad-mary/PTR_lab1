defmodule Printer do
  use GenServer

  def start_link(id) do
    GenServer.start_link(__MODULE__, id)
  end

  def init(state) do
    {:ok, state}
  end

  def print(worker_pid, twt) do
    GenServer.cast(worker_pid, twt)
  end

  def handle_cast(:kill, state) do
    IO.puts(IO.ANSI.format([:red,"=== Kill printer #{state} ==="]))
    PrinterSupervisor.restart_worker(state)
    {:stop, :normal, state}
  end

  def handle_cast(twt, state) do
    hash = :crypto.hash(:md5, twt) |> Base.encode16()
    case Cache.get(hash) do
      true ->
        LoadBalancer.release_worker(state)
        {:noreply, state}
      false ->
        Cache.put(hash)
        twt = filter_bad_words(twt)
        IO.puts("Printer #{inspect(state)} : #{inspect(twt)}")
        LoadBalancer.release_worker(state)
        #IO.puts(IO.ANSI.format([:yellow, "Printer #{inspect(state)} is released."]))
        {:noreply, state}
    end
  end

  defp filter_bad_words(twt) do
    encoded_twt = URI.encode(twt)
    url = "https://www.purgomalum.com/service/plain?text=#{encoded_twt}"
    response = HTTPoison.get!(url)
    response.body
  end

end
