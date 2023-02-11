defmodule Print do
  def start do
    spawn(__MODULE__, :loop, [])
  end

  def loop do
    receive do
      {message} ->
        IO.puts(message)
        loop()
    end
  end
end
