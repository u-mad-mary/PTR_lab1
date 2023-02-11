defmodule Modifier do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      message ->
        case message do
          integer when is_integer(message) ->
            IO.puts "Received: #{integer}"
            loop()
          bitstring when is_bitstring(message) ->
            IO.puts "Received: #{bitstring}"
            loop()
          _ ->
            IO.puts "Received: I don’t know how to HANDLE this!"
            loop()
        end
    end
  end
end

# pid = Modifier.start
# spawn fn -> send(pid, 10) end | to avoid printing input
