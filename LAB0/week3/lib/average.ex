defmodule Average do
  def start do
    spawn(__MODULE__, :loop, [0, 1])
  end

  @spec loop(number, number) :: no_return
  def loop(sum, count) do
    average = sum / count
    IO.puts("Current average is #{average}.")

    receive do
      number ->
        new_sum = sum + number
        new_count = count + 1
        loop(new_sum, new_count)
    end
  end
end

# pid = Average.start
# spawn fn -> send(pid, 10) end | to avoid printing the input
