defmodule Consumer do
  require Logger
  use GenServer

  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  def init(socket) do
    consumer_pid = self()
    Task.start_link(fn -> serve(socket, consumer_pid) end)
    {:ok, socket}
  end

  def send_data(pid, topic, data) do
    GenServer.cast(pid, {:send_data, topic, data})
  end

  def handle_cast({:send_data, topic, data}, socket) do
    write_line("topic #{topic}\n#{data}\npublished\n", socket)
    {:noreply, socket}
  end

  def subscribe(topic, consumer_pid, socket) do
    Logger.info("^^^ Consumer subscribes to topic #{topic} ^^^")
    Consumers.subscribe(consumer_pid, topic)
    messages = DataSuper.get_data(topic)
    Enum.each(messages, fn {date, data} -> write(topic, date, data, socket) end)
    {:ok, socket}
  end

  def unsubscribe(topic, consumer_pid, socket) do
    Logger.info("^^^ Consumer unsubscribes from topic #{topic} ^^^")
    Consumers.unsubscribe(consumer_pid, topic)
    {:ok, socket}
  end

  defp serve(socket, consumer_pid) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, line} ->
        case String.split(line) do
          ["subscribe", topic] ->
            topic = String.trim(topic)
            subscribe(topic, consumer_pid, socket)
          ["unsubscribe", topic] ->
            topic = String.trim(topic)
            unsubscribe(topic, consumer_pid, socket)
          _ ->
            Logger.info("=== Invalid command #{line} ===")
        end
      {:error, err} ->
        Logger.info("=== Module: #{__MODULE__} Error: #{inspect(err)} ===")
    end
    serve(socket, consumer_pid)
  end

  defp write(topic, date, data, socket) do
    write_line("topic #{topic}\n#{data}\npublished on: #{date} \n", socket)
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end

end
