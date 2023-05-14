defmodule Publisher do
  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info("~~~ Publishers can be established on port #{port} ~~~")
    acceptor(socket)
  end

  defp acceptor(socket) do
    {:ok, consumer} = :gen_tcp.accept(socket)
    {:ok, pid} = Task.Supervisor.start_child(MessageBroker, fn -> serve(consumer) end)
    :ok = :gen_tcp.controlling_process(consumer, pid)
    acceptor(socket)
  end

  defp serve(socket) do
    case read_topic(socket) do
      {:ok, topic} ->
        data = read_data(socket, "")
        DataSuper.publish(topic, data)
      {:error} ->
        write_line("error", socket)
    end
    serve(socket)
  end

  defp read_topic(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, line} ->
        ["topic", topic] = String.split(line, " ")
        {:ok, String.trim(topic)}
      {:error, _reason} ->
        {:error}
    end
  end

  defp read_data(socket, data) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, line} ->
        if String.trim(line) == "save" do
          data
        else
          read_data(socket, data <> line)
        end
      {:error, _reason} ->
        data
    end
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
