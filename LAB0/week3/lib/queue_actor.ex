defmodule Queue do

  def start() do
    GenServer.start(__MODULE__, [])
  end

  def init(args) do
    Server.init(args)
  end

  def push(pid, item) do
    GenServer.call(pid, {:push, item})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def handle_call(request, from, state) do
    Server.handle_call(request, from, state)
  end
end

defmodule Server do
  use GenServer

  def init(args) do
    {:ok, args}
  end

  def handle_call({:push, item}, _from, queue) do
    {:reply, :ok, [item | queue]}
  end

  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:pop, _from, [item | rest]) do
    {:reply, item, rest}
  end
end

# {:ok, pid} = GenServer.start(Queue, [])
# Queue.push(pid,42)
# Queue.pop(pid)
