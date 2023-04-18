defmodule Cache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    {:ok, state}
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def set(pid, key) do
    GenServer.cast(pid, {:set, key})
  end

  def handle_call({:get, key}, _from, state) do
    case Map.fetch(state, key) do
      {:ok, _} -> {:reply, true, state}
      :error -> {:reply, false, state}
    end
  end

  def handle_cast({:set, key}, state) do
    new_state = Map.put(state, key, true)
    {:noreply, new_state}
  end
end
