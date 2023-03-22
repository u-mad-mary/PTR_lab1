defmodule ReaderSupervisor do
  use Supervisor

  def start_link do
    #IO.puts(IO.ANSI.format([:green, "=== ReaderSupervisor has started ==="]))
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)

  end

  def init([]) do
    children = [
      %{
        id: :reader_1,
        start: {Reader, :start_link, ["http://localhost:4000/tweets/1"]}
      },
      %{
        id: :reader_2,
        start: {Reader, :start_link, ["http://localhost:4000/tweets/2"]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
