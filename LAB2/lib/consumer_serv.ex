defmodule ConsumerServ do
  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
    Logger.info(" ~~~ Consumers can be established on port #{port} ~~~")
    acceptor(socket)
  end

  defp acceptor(socket) do
    {:ok, consumer} = :gen_tcp.accept(socket)
    case ConsumerSuper.create_consumer(consumer) do
      {:ok, pid} ->
        :ok = :gen_tcp.controlling_process(consumer, pid)
      {:error} ->
        write_line("error", consumer)
        :gen_tcp.close(consumer)
    end
    acceptor(socket)
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
