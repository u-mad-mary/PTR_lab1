defmodule Cache do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ets.new(:cache, [:set, :public]))
  end

  def init(ets_table) do
    {:ok, ets_table}
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def set(pid, key) do
    GenServer.cast(pid, {:set, key})
  end

  def handle_call({:get, key}, _from, ets_table) do
    case :ets.lookup(ets_table, key) do
      [{^key, _}] -> {:reply, true, ets_table}
      [] -> {:reply, false, ets_table}
    end
  end

  def handle_cast({:set, key}, ets_table) do
    :ets.insert(ets_table, {key, true})
    {:noreply, ets_table}
  end
end
