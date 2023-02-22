defmodule StringCleaner do
  use Supervisor

  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      FirstWorker,
      SecondWorker,
      ThirdWorker
    ]
    |> Enum.map(&worker_spec(&1))

    Supervisor.init(children, strategy: :one_for_all)
  end

  def clean(string) do
    [FirstWorker, SecondWorker, ThirdWorker]
    |> Enum.reduce(string, fn worker, str ->
      GenServer.call(worker, str)
    end)
  end

  defp worker_spec(module) do
    %{
      id: module,
      start: {module, :start_link, []}
    }
  end
end

defmodule FirstWorker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(string, _from, state) do
    {:reply, String.split(string), state}
  end
end

defmodule SecondWorker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(string, _from, state) do
    string = Enum.map(string, fn word ->
      String.downcase(word)
      |> String.replace("n", "_ULALA_")
      |> String.replace("m", "n")
      |> String.replace("_ULALA_", "m")
    end)

    {:reply, string , state}
  end
end

defmodule ThirdWorker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(string, _from, state) do

    {:reply, Enum.join(string, " "), state}
  end
end

# StringCleaner.start_link()
# StringCleaner.clean("Messy nu messy doesn't matter. A problem is a problem.")
