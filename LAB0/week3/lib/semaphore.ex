defmodule Semaphore do
  def create(value) do
    GenServer.start(__MODULE__, value)
  end

  def init(args) do
    SemaphoreServer.init(args)
  end

  def acquire(semaphore_pid) do
    GenServer.call(semaphore_pid, :acquire)
  end

  def release(semaphore_pid) do
    GenServer.call(semaphore_pid, :release)
  end

  def handle_call(request, from, state) do
    SemaphoreServer.handle_call(request, from, state)
  end
end

defmodule SemaphoreServer do
  use GenServer

  def init(value) do
    {:ok, {value, value}}
  end

  def handle_call(:acquire, _from, {count, available}) do
    if available >= 0 do
      {:reply, :acquired, {count, available - 1}}
    else
      {:reply, :error, {count, available}}
    end
  end

  def handle_call(:release, _from, {count, available}) do
    if available < count do
      {:reply, :released, {count, available + 1}}
    else
      {:reply, :error, {count, available}}
    end
  end
end

# {:ok, mutex} = Semaphore.create(0)
# Semaphore.acquire(mutex)
# Semaphore.release(mutex)
