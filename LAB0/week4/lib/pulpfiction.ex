defmodule TheSupervisor do
  def start do
    spawn_link(fn -> talk(1) end)
  end

  defp talk(count) when count <= 1 do
    IO.puts "Actor One: What does Marcellus look like?"
    :timer.sleep(2000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    IO.puts "Actor One: What country you from?!"
    :timer.sleep(1000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    IO.puts "Actor One: What ain't no country I've ever heard of! They speak English in What?"
    :timer.sleep(1000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    IO.puts "Actor One: English mf do you speak it!?"
    :timer.sleep(1000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    IO.puts "Actor One: Describe what Marcellus Wallace looks like."
    :timer.sleep(1000)
    IO.puts "Actor Two: Yes"
    :timer.sleep(1000)

    IO.puts "Actor One: Dose he look like a btch?"
    :timer.sleep(1000)
    IO.puts "Actor Two: He's Black"
    :timer.sleep(1000)

    IO.puts "Actor One: Say what again. SAY WHAT again! And I dare you, I double dare you mf! Say what one more time."
    :timer.sleep(1000)
    IO.puts "Actor Two: What"
    :timer.sleep(1000)

    talk(count + 1)
  end

  defp talk(_count) do
    IO.puts "===BANG==="
    :timer.sleep(1000)
    Process.exit(self(), :kill)
  end
end

defmodule TheVictim do
  def start do
    spawn_link(fn -> talk(1) end)
  end

  defp talk(count) when count <= 7 do
    receive do
      _ ->
        IO.puts "Actor One: What"
        :timer.sleep(1000)
        talk(count + 1)
    end
  end

  defp talk(_count) do
    IO.puts "..."
  end
end

# TheSupervisor.start
# TheVictim.start
